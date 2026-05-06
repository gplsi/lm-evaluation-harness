#!/usr/bin/env bash
source /home/gplsi/rst29/anaconda3/etc/profile.d/conda.sh
conda activate hardness

set -euo pipefail
# Usage: ./test_cieacova.sh [OUTPUT_ROOT]
# OUTPUT_ROOT sets the directory prefix for results. Defaults to outputs/cieacova.

OUTPUT_ROOT=${1:-"outputs/cieacova"}
TASKS="cieacova_word,cieacova_choice,cieacova_choice_gen"
COMMON_ARGS=(--tasks "$TASKS" --device cuda:0 --batch_size 5 --log_samples --seed 1234)

if ! command -v lm_eval >/dev/null 2>&1; then
	echo "lm_eval command not found in PATH" >&2
	exit 1
fi

HF_INSTRUCT_MODELS=(
 /home/gplsi/GPLSI/ALIA/modelos/Instruction/ALIA_instruction_aitana_7b_v1_data_v12_va_fsdp_3_epoch2/hf_models/step-015535
 /home/gplsi/GPLSI/ALIA/modelos/Instruction/Salamandra_7B_Instruct_BSC/salamandra_7b_instruct
 /home/gplsi/GPLSI/ALIA/modelos/Instruction/Salamandra_2B_Instruct_BSC/salamandra-2b-instruct
 /home/gplsi/GPLSI/ALIA/modelos/Instruction/ALIA_instruction_sala_2b_v19_data_v13_1_va_fsdp_3_language_long_sequence_3_epoch/hf_models/final
 /home/gplsi/GPLSI/ALIA/modelos/Instruction/ALIA_instruction_sala_2b_v18_data_v12_va_ca_fsdp_3_language_long_sequence_3_epoch/hf_models/final
 /home/gplsi/GPLSI/ALIA/modelos/Instruction/ALIA_instruction_sala_2b_v17_data_v12_va_fsdp_3_language_long_sequence_3_epoch/hf_models/final
 /home/gplsinas/HF_models/ALIA-40B-instruct
)

VLLM_INSTRUCT_MODELS=(
  /home/gplsi/GPLSI/ALIA/modelos/Instruction/ALIA_instruction_qwen_2b_v1_data_v1_valencian_fsdp_chat_3_language_long_sequence_3_epoch/hf_models/step-002184
  /home/gplsi/GPLSI/ALIA/modelos/Instruction/Qwen/hf_models/Latxa-Qwen3-VL-2B-Instruct
  /home/gplsi/GPLSI/ALIA/modelos/Instruction/Qwen/hf_models/Qwen3-VL-2B-Instruct
  /home/gplsinas/HF_models/models--openai--gpt-oss-20b/snapshots/6cee5e81ee83917806bbde320786a8fb61efebee
)

HF_BASE_MODELS=(
    /home/gplsinas/ALIA/modelos/Continual/Salamandra-2B
	/home/gplsi/GPLSI/ALIA/modelos/Continual/Aitana-s2b-c0dc29/hf_models/e-001-gs-009208
	/home/gplsinas/ALIA/modelos/Continual/Aitana_s2b-c0dc17/hf_models/e-002-gs-075502
	/home/gplsinas/ALIA/modelos/Continual/aitana-s2b-c3dc1/hf_model/e-002-gs-016190
	/home/gplsinas/ALIA/modelos/Continual/aitana-s2b-c0dc40x48/hf_models/e-001-gs-003004
	/home/gplsi/GPLSI/ALIA/modelos/Continual/AITANA_7B_BSC_TRAIN/cpt_7b_after_annealing_gplsi
	/home/gplsinas/ALIA/modelos/Continual/Salamandra_7B/Salamandra-7B
	/home/gplsinas/ALIA/modelos/Continual/aitana-s2b-c3dc3/hf/e-002-gs-029473
	/home/gplsi/GPLSI/ALIA/modelos/Continual/aitana-s2b-c5dc40x48/hf_models/e-001-gs-003004
	/home/gplsi/GPLSI/ALIA/modelos/Continual/aitana-s2b-c5dc49x50_hf/e-001-gs-001591
	/home/gplsinas/HF_models/ALIA-40B-base
)

missing_models=()
failed_models=()

check_model_path() {
	local model_path="$1"
	if [[ ! -d "$model_path" ]]; then
		echo "Model path not found: $model_path" >&2
		missing_models+=("$model_path")
		return 1
	fi
	return 0
}

run_hf_instruct() {
	local model_path="$1"
	local out_dir="$OUTPUT_ROOT/instruct/$(basename "$model_path")"
	local model_args="pretrained=$model_path"
	# gpt-oss supports explicit thinking traces; disable them for fair scoring.
	if [[ "$model_path" == *"gpt-oss-20b"* ]]; then
		model_args+=",enable_thinking=false,think_end_token=<|message|>"
	fi
	mkdir -p "$out_dir"
	lm_eval --model hf --model_args "$model_args" "${COMMON_ARGS[@]}" --output_path "$out_dir" --apply_chat_template
}

run_vllm_instruct() {
	local model_path="$1"
	local out_dir="$OUTPUT_ROOT/instruct/$(basename "$model_path")"
	local model_args="pretrained=$model_path"
	if [[ "$model_path" == *"gpt-oss-20b"* ]]; then
		model_args+=",max_model_len=32768,think_end_token=<|message|>"
	fi
	mkdir -p "$out_dir"
	lm_eval --model vllm --model_args "$model_args" "${COMMON_ARGS[@]}" --output_path "$out_dir" --apply_chat_template
}

run_hf_base() {
	local model_path="$1"
	local out_dir="$OUTPUT_ROOT/base/$(basename "$model_path")"
	mkdir -p "$out_dir"
	lm_eval --model hf --model_args "pretrained=$model_path" "${COMMON_ARGS[@]}" --output_path "$out_dir"
}

run_with_checks() {
	local label="$1"
	local runner="$2"
	local model_path="$3"
	if ! check_model_path "$model_path"; then
		return
	fi
	if ! "$runner" "$model_path"; then
		echo "lm_eval failed for $label: $model_path" >&2
		failed_models+=("$model_path")
	fi
}

mkdir -p "$OUTPUT_ROOT"

for model in "${HF_INSTRUCT_MODELS[@]}"; do
	run_with_checks "hf_instruct" run_hf_instruct "$model"
done

for model in "${VLLM_INSTRUCT_MODELS[@]}"; do
	run_with_checks "vllm_instruct" run_vllm_instruct "$model"
done

for model in "${HF_BASE_MODELS[@]}"; do
	run_with_checks "hf_base" run_hf_base "$model"
done

if (( ${#missing_models[@]} > 0 || ${#failed_models[@]} > 0 )); then
	if (( ${#missing_models[@]} > 0 )); then
		echo "Missing model paths:" >&2
		printf '  %s\n' "${missing_models[@]}" >&2
	fi
	if (( ${#failed_models[@]} > 0 )); then
		echo "Runs that failed:" >&2
		printf '  %s\n' "${failed_models[@]}" >&2
	fi
	exit 1
fi

