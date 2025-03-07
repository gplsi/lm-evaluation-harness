#!/bin/bash
date=$(date '+%d-%m-%Y')
job_name=$1_${date}
tensor_parallelism="False"
# tensor_parallelism="True"
computer="mn5"


models=(
# 	/gpfs/projects/bsc88/hf-models/Mistral-7B-Instruct-v0.3
#    /gpfs/projects/bsc88/nemo-models/7b_8k_299516416_step_1160000_decompressed_nemo
#     /gpfs/projects/bsc88/hf-models/FLOR-760M
#     /gpfs/projects/bsc88/hf-models/FLOR-1.3B
#  	/gpfs/projects/bsc88/hf-models/FLOR-6.3B
#     /gpfs/projects/bsc88/hf-models/Aitana-6.3B
# 	/gpfs/projects/bsc88/hf-models/falcon-7b
# 	/gpfs/projects/bsc88/hf-models/gemma-2b
# 	/gpfs/projects/bsc88/hf-models/gemma-7b
# 	/gpfs/projects/bsc88/hf-models/mGPT-13B
# 	/gpfs/projects/bsc88/hf-models/xglm-564M
# 	/gpfs/projects/bsc88/hf-models/xglm-2.9B
# 	/gpfs/projects/bsc88/hf-models/xglm-1.7B
# 	/gpfs/projects/bsc88/hf-models/xglm-4.5B
# 	/gpfs/projects/bsc88/hf-models/xglm-7.5B
# 	/gpfs/projects/bsc88/hf-models/latxa-7b-v1.1
# 	/gpfs/projects/bsc88/hf-models/latxa-13b-v1.1
# 	/gpfs/projects/bsc88/hf-models/Meta-Llama-3-8B
# 	/gpfs/projects/bsc88/hf-models/Carvalho_pt-gl-1.3B
#  	/gpfs/projects/bsc88/hf-models/bloom-1b1
# 	/gpfs/projects/bsc88/hf-models/bloom-3b
#  	/gpfs/projects/bsc88/hf-models/bloom-1b7
#  	/gpfs/projects/bsc88/hf-models/bloom-7b1
#  	/gpfs/projects/bsc88/hf-models/Mistral-7B-v0.1
#  	/gpfs/projects/bsc88/hf-models/Mistral-7B-v0.1,max_length=2000
#  	/gpfs/projects/bsc88/hf-models/Mistral-7B-v0.1,max_length=2500
#  	/gpfs/projects/bsc88/hf-models/Mistral-7B-v0.1,max_length=5000
#     /gpfs/projects/bsc88/hf-models/Carballo-bloom-1.3B
#     /gpfs/projects/bsc88/hf-models/Carballo-cerebras-1.3B
#     /gpfs/projects/bsc88/hf-models/mGPT
# 	/gpfs/projects/bsc88/hf-models/OLMo-1.7-7B-hf
#     /gpfs/projects/bsc88/hf-models/TowerBase-7B-v0.1
# 	/gpfs/projects/bsc88/hf-models/TowerBase-13B-v0.1
# 	/gpfs/projects/bsc88/hf-models/sabia-7b
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-eu5,dtype=float16,max_length=5000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-eu5,dtype=float16,max_length=2500
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-eu5,dtype=float16,max_length=2000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-es-en,dtype=float16,max_length=5000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-es-en,dtype=float16,max_length=2500
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-es-en,dtype=float16,max_length=2000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-eu5,dtype=float16
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-es-en,dtype=float16
#     /gpfs/projects/bsc88/hf-models/CataLlama-v0.1-Base
# 	/gpfs/projects/bsc88/hf-models/gervasio-7b-portuguese-ptpt-decoder
# 	/gpfs/projects/bsc88/hf-models/GlorIA-1.3B
# 	/gpfs/projects/bsc88/hf-models/Qwen-1_8B
# 	/gpfs/projects/bsc88/hf-models/Qwen-7B
# 	/gpfs/projects/bsc88/hf-models/Qwen-14B
# 	/gpfs/projects/bsc88/hf-models/Llama-2-7b-hf
# 	/gpfs/projects/bsc88/hf-models/galactica-6.7b
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-eu5,dtype=auto,max_length=1000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-eu5-instruct,dtype=auto,max_length=1000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-de-en,dtype=auto,max_length=1000
# 	/gpfs/projects/bsc88/hf-models/occiglot-7b-de-en-instruct,dtype=auto,max_length=1000
#     /gpfs/projects/bsc88/nvidia_gpt_to_huggingface/models/gpt_7b_improved_hard_dataset_39%.nemo
# 	/gpfs/projects/bsc88/nvidia_gpt_to_huggingface/models/gpt_7b_improved_soft_dataset_39%.nemo
# 	/gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_0.5/results/gpt_2b_improved/results/1414044/checkpoints/alpha_0.5.nemo
# 	/gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_1/results/gpt_2b_improved/results/1409160/checkpoints/alpha_1.nemo
# 	/gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_0/results/gpt_2b_improved_64_nodes/results/1525312/checkpoints/alpha_0.nemo
# 	/gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_0.25/results/gpt_2b_improved_64_nodes/results/1525563/checkpoints/alpha_0.25.nemo
# 	/gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_1/results/gpt_2b_improved_64_nodes/results/1527034/checkpoints/alpha_1.nemo
#     /gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_0.5/results/gpt_2b_improved_64_nodes_rerun/results/1560101/checkpoints/alpha_0.5.nemo
# 	/gpfs/projects/bsc88/preproduction/tokenizer_experiments/alpha_0.75/results/gpt_2b_improved_64_nodes_rerun/results/1597614/checkpoints/alpha_0.75.nemo
# 	/gpfs/projects/bsc88/preproduction/test_12_03_2024/results/7b_final_tests/results/1635484/checkpoints/7b_final_tests.nemo
# 	/gpfs/projects/bsc88/preproduction/test_12_03_2024/results/7b_final_tests/results/1635483/checkpoints/7b_final_tests.nemo
#     /gpfs/projects/bsc88/hf-models/Mistral-tb-v0.1.nemo
#     /gpfs/projects/bsc88/preproduction/test_12_03_2024/results/7b_final_tests/results/1745458/checkpoints/7b_final_tests.nemo
#     /gpfs/projects/bsc88/preproduction/test_12_03_2024/results/7b_final_tests/results/1745657/checkpoints/7b_final_tests.nemo
# 	/gpfs/projects/bsc88/preproduction/test_12_03_2024/results/7b_final_tests/results/1744355/checkpoints/7b_final_tests.nemo
#     /gpfs/projects/bsc88/preproduction/test_12_03_2024/results/bsc_7b/results/7b_4k/checkpoints/last_consumed_samples=51200000_val_loss=1.69/7b_4k_consumed_samples=51200000_val_loss=1.69.nemo
# 	/gpfs/projects/bsc88/preproduction/test_12_03_2024/results/bsc_7b/results/7b_8k/checkpoints/last_consumed_samples=25600512_val_loss=1.67/7b_8k_consumed_samples=25600512_val_loss=1.67.nemo
# 	/gpfs/projects/bsc88/nemo-models/7b_4k_51200000.nemo
# 	/gpfs/projects/bsc88/nemo-models/7b_8k_25600512.nemo
#     /gpfs/projects/bsc88/nemo-models/7b_4k_87040000.nemo
# 	/gpfs/projects/bsc88/nemo-models/7b_8k_43520000.nemo
#     /gpfs/projects/bsc88/nemo-models/7b_8k_89600000.nemo
# 	/gpfs/projects/bsc88/nvidia_gpt_to_huggingface/checkpoint_converters/converted_model_hf
#      /gpfs/projects/bsc88/hf-models/gpt-neo-1.3B
#     /gpfs/projects/bsc88/MN4/bsc88/huggingface/models/FLOR-1.3B-Instructed
# 	/gpfs/projects/bsc88/MN4/bsc88/huggingface/models/FLOR-1.3B_float16
#     /gpfs/projects/bsc88/nemo-models/40b_8k_43520000.nemo
#     /gpfs/projects/bsc88/nemo-models/40b_8k_43520000_decompressed_nemo
# 	/gpfs/projects/bsc88/nemo-models/7b_8k_179200000_decompressed_nemo
#    /gpfs/projects/bsc88/nemo-models/40b_8k_89600000_decompressed_nemo
#    /gpfs/projects/bsc88/nemo-models/7b_8k_266240000_decompressed_step_520000_nemo
# 	/gpfs/projects/bsc88/nemo-models/7b_8k_266240000_step_550007_decompressed_nemo
#     /gpfs/projects/bsc88/nemo-models/7b_8k_63996416_step_700000_decompressed_nemo
#     /gpfs/projects/bsc88/nemo-models/40b_4k_512N_bf16_51200000_step_50000_decompressed_nemo
# 	/gpfs/projects/bsc88/nemo-models/40b_4k_512N_bf16_88064000_step_86000_decompressed_nemo
#     /gpfs/projects/bsc88/nemo-models/7b_8k_151036416_step_870000_decompressed_nemo
# 	/gpfs/projects/bsc88/nemo-models/40b_4k_180224000_step_176000_decompressed_nemo
)

datasets=(
# 	eus_reading
#     parafrases_gl
#     paws_en_corrected
#     phrases_va
#     mgsm_direct_en_corrected
#     mgsm_direct_ca
# 	veritasqa_gen_ca
# 	veritasqa_mc1_ca
# 	veritasqa_mc2_ca
# 	phrases_ca-va
# 	phrases_va-ca
# 	phrases_es-va
# 	phrases_va-es
# 	paws_es
# 	escola
# 	veritasqa_gen_es
# 	veritasqa_mc1_es
# 	veritasqa_mc2_es
# 	eus_reading
# 	openbookqa_gl
# 	veritasqa_gen_gl
# 	veritasqa_mc1_gl
# 	veritasqa_mc2_gl
# 	truthfulqa_gl_gen
# 	truthfulqa_gl_mc1
# 	truthfulqa_gl_mc2
#     assin_entailment
# 	belebele_por_Latn
# 	mgsm_direct_en_corrected
# 	mgsm_direct_es_corrected
#     openbookqa_gl
#     flores_eu
#     paws_es
#     catcola
#     escola
#     dbpedia
# 	truthfulqa_gl
#     teca
#    summarization_gl
#    basque-glue
#     cabreu
# 	xlsum_es
# 	eus_reading
# 	mgsm_native_cot_eu
# 	summarization_gl
# 	portuguese_bench
   catalan_bench_subtasks
   spanish_bench_subtasks
   galician_bench_subtasks
   basque_bench_subtasks
   iberobench_en_subtasks
   portuguese_bench_subtasks
# 	flores_es
#     catalan_bench
#     spanish_bench
#     galician_bench
#     basque_bench
# 	iberobench_en
#     portuguese_bench
# 	  generation_test
# 	  generation_test_instruction_eu
# 	  generation_test_instruction_ca
# 	  generation_test_instruction_es
# 	  generation_test_instruction_en
)

num_fewshots=( 5 )

catalan_bench_subtasks=(
    belebele_cat_Latn
    xnli_ca        
    catcola        
    copa_ca        
    openbookqa_ca  
    parafraseja    
    paws_ca        
    piqa_ca        
    siqa_ca        
    teca           
    wnli_ca        
    arc_ca_easy    
    arc_ca_challenge
    xstorycloze_ca 
    xquad_ca       
    catalanqa      
    coqcat
    flores_ca
    cabreu         
    mgsm_direct_ca 
    veritasqa_gen_ca
    veritasqa_mc1_ca
    veritasqa_mc2_ca
    phrases_va
)

spanish_bench_subtasks=(
    belebele_spa_Latn
    wnli_es
    xnli_es
	escola
	paws_es
    xstorycloze_es
    xquad_es
    xlsum_es
	mgsm_direct_es_v2
	flores_es
    veritasqa_gen_es
    veritasqa_mc1_es
    veritasqa_mc2_es
    phrases_es
)

galician_bench_subtasks=(
    belebele_glg_Latn
    flores_gl       
    galcola         
    summarization_gl
    parafrases_gl   
    paws_gl         
    mgsm_direct_gl
    openbookqa_gl	
    veritasqa_gen_gl
    veritasqa_mc1_gl
    veritasqa_mc2_gl
    truthfulqa_gl	
)

basque_bench_subtasks=(
    belebele_eus_Latn
    xstorycloze_eu
    flores_eu
    eus_reading
    eus_proficiency
    eus_trivia
    eus_exams_eu
    basque-glue
    xnli_eu
    xnli_eu_native
    wnli_eu
    xcopa_eu
    mgsm_direct_eu
    mgsm_native_cot_eu
)

iberobench_en_subtasks=(
    belebele_eng_Latn
    arc_easy
    arc_challenge
    hellaswag
    copa
    xstorycloze_en
    xnli_en
    xquad_en
    openbookqa
    piqa
    social_iqa
    cola
    wnli
    truthfulqa
    paws_en_corrected
    veritasqa_gen_en
    veritasqa_mc1_en
    veritasqa_mc2_en
    mgsm_direct_en_corrected
)

portuguese_bench_subtasks=(
	belebele_por_Latn
	flores_pt
	assin_paraphrase
	assin_entailment
)

xstorycloze_list=(
#     "xstorycloze_ar"
    "xstorycloze_en"
    "xstorycloze_es"
    "xstorycloze_eu"
#     "xstorycloze_hi"
#     "xstorycloze_id"
#     "xstorycloze_my"
#     "xstorycloze_ru"
#     "xstorycloze_sw"
#     "xstorycloze_te"
#     "xstorycloze_zh"
)           
          
flores_list=(
    "flores_ca-de"
    "flores_ca-en"
    "flores_ca-es"
    "flores_ca-eu"
    "flores_ca-fr"
    "flores_ca-gl"
    "flores_ca-it"
    "flores_de-ca"
    "flores_en-ca"
    "flores_en-es"
    "flores_es-ca"
    "flores_es-en"
    "flores_es-eu"
    "flores_es-gl"
    "flores_eu-ca"
    "flores_eu-es"
    "flores_eu-gl"
    "flores_fr-ca"
    "flores_gl-ca"
    "flores_gl-es"
    "flores_gl-eu"
    "flores_it-ca"
)

xquad_list=(
    "xquad_ar"
    "xquad_ca"
    "xquad_de"
    "xquad_el"
    "xquad_en"
    "xquad_es"
    "xquad_hi"
    "xquad_ro"
    "xquad_ru"
    "xquad_th"
    "xquad_tr"
    "xquad_vi"
    "xquad_zh"
)           

xnli_list=(
    "xnli_ar"
    "xnli_bg"
    "xnli_ca"
    "xnli_de"
    "xnli_el"
    "xnli_en"
    "xnli_es"
    "xnli_fr"
    "xnli_hi"
    "xnli_ru"
    "xnli_sw"
    "xnli_th"
    "xnli_tr"
    "xnli_ur"
    "xnli_vi"
    "xnli_zh"
)

xlsum_list=(
    "xlsum_en"
    "xlsum_es"
#     "xlsum_fr"
#     "xlsum_pt"
#     "xlsum_sr"
#     "xlsum_uk"
)


paws_list=(
#     "paws_ca"
#     "paws_de"
#     "paws_en"
#     "paws_es"
#     "paws_fr"
    "paws_gl"
#     "paws_ja"
#     "paws_ko"
#     "paws_zh"
)

belebele_list=(
#     "belebele_acm_Arab"
#     "belebele_afr_Latn"
#     "belebele_als_Latn"
#     "belebele_amh_Ethi"
#     "belebele_apc_Arab"
#     "belebele_arb_Arab"
#     "belebele_arb_Latn"
#     "belebele_ars_Arab"
#     "belebele_ary_Arab"
#     "belebele_arz_Arab"
#     "belebele_asm_Beng"
#     "belebele_azj_Latn"
#     "belebele_bam_Latn"
#     "belebele_ben_Beng"
#     "belebele_ben_Latn"
#     "belebele_bod_Tibt"
#     "belebele_bul_Cyrl"
    "belebele_cat_Latn"
#     "belebele_ceb_Latn"
#     "belebele_ces_Latn"
#     "belebele_ckb_Arab"
#     "belebele_dan_Latn"
#     "belebele_deu_Latn"
#     "belebele_ell_Grek"
    "belebele_eng_Latn"
#     "belebele_est_Latn"
    "belebele_eus_Latn"
#     "belebele_fin_Latn"
#     "belebele_fra_Latn"
#     "belebele_fuv_Latn"
#     "belebele_gaz_Latn"
    "belebele_glg_Latn"
#     "belebele_grn_Latn"
#     "belebele_guj_Gujr"
#     "belebele_hat_Latn"
#     "belebele_hau_Latn"
#     "belebele_heb_Hebr"
#     "belebele_hin_Deva"
#     "belebele_hin_Latn"
#     "belebele_hrv_Latn"
#     "belebele_hun_Latn"
#     "belebele_hye_Armn"
#     "belebele_ibo_Latn"
#     "belebele_ilo_Latn"
#     "belebele_ind_Latn"
#     "belebele_isl_Latn"
#     "belebele_ita_Latn"
#     "belebele_jav_Latn"
#     "belebele_jpn_Jpan"
#     "belebele_kac_Latn"
#     "belebele_kan_Knda"
#     "belebele_kat_Geor"
#     "belebele_kaz_Cyrl"
#     "belebele_kea_Latn"
#     "belebele_khk_Cyrl"
#     "belebele_khm_Khmr"
#     "belebele_kin_Latn"
#     "belebele_kir_Cyrl"
#     "belebele_kor_Hang"
#     "belebele_lao_Laoo"
#     "belebele_lin_Latn"
#     "belebele_lit_Latn"
#     "belebele_lug_Latn"
#     "belebele_luo_Latn"
#     "belebele_lvs_Latn"
#     "belebele_mal_Mlym"
#     "belebele_mar_Deva"
#     "belebele_mkd_Cyrl"
#     "belebele_mlt_Latn"
#     "belebele_mri_Latn"
#     "belebele_mya_Mymr"
#     "belebele_nld_Latn"
#     "belebele_nob_Latn"
#     "belebele_npi_Deva"
#     "belebele_npi_Latn"
#     "belebele_nso_Latn"
#     "belebele_nya_Latn"
#     "belebele_ory_Orya"
#     "belebele_pan_Guru"
#     "belebele_pbt_Arab"
#     "belebele_pes_Arab"
#     "belebele_plt_Latn"
#     "belebele_pol_Latn"
#     "belebele_por_Latn"
#     "belebele_ron_Latn"
#     "belebele_rus_Cyrl"
#     "belebele_shn_Mymr"
#     "belebele_sin_Latn"
#     "belebele_sin_Sinh"
#     "belebele_slk_Latn"
#     "belebele_slv_Latn"
#     "belebele_sna_Latn"
#     "belebele_snd_Arab"
#     "belebele_som_Latn"
#     "belebele_sot_Latn"
    "belebele_spa_Latn"
#     "belebele_srp_Cyrl"
#     "belebele_ssw_Latn"
#     "belebele_sun_Latn"
#     "belebele_swe_Latn"
#     "belebele_swh_Latn"
#     "belebele_tam_Taml"
#     "belebele_tel_Telu"
#     "belebele_tgk_Cyrl"
#     "belebele_tgl_Latn"
#     "belebele_tha_Thai"
#     "belebele_tir_Ethi"
#     "belebele_tsn_Latn"
#     "belebele_tso_Latn"
#     "belebele_tur_Latn"
#     "belebele_ukr_Cyrl"
#     "belebele_urd_Arab"
#     "belebele_urd_Latn"
#     "belebele_uzn_Latn"
#     "belebele_vie_Latn"
#     "belebele_war_Latn"
#     "belebele_wol_Latn"
#     "belebele_xho_Latn"
#     "belebele_yor_Latn"
#     "belebele_zho_Hans"
#     "belebele_zho_Hant"
#     "belebele_zsm_Latn"
#     "belebele_zul_Latn"
#SBATCH --nodelist=as01r4b32
)

macro_tasks=( "pawsx" "xstorycloze" "xlsum" "xnli" "xquad" "belebele" "flores" "catalan_bench_subtasks" "spanish_bench_subtasks" "galician_bench_subtasks" "basque_bench_subtasks" "iberobench_en_subtasks" "portuguese_bench_subtasks" )

declare -A macro_tasks_lists

macro_tasks_lists["pawsx"]=${paws_list[@]}
macro_tasks_lists["xstorycloze"]=${xstorycloze_list[@]}
macro_tasks_lists["xlsum"]=${xlsum_list[@]}
macro_tasks_lists["xnli"]=${xnli_list[@]}
macro_tasks_lists["xquad"]=${xquad_list[@]}
macro_tasks_lists["belebele"]=${belebele_list[@]}
macro_tasks_lists["flores"]=${flores_list[@]}
macro_tasks_lists["catalan_bench_subtasks"]=${catalan_bench_subtasks[@]}
macro_tasks_lists["spanish_bench_subtasks"]=${spanish_bench_subtasks[@]}
macro_tasks_lists["galician_bench_subtasks"]=${galician_bench_subtasks[@]}
macro_tasks_lists["basque_bench_subtasks"]=${basque_bench_subtasks[@]}
macro_tasks_lists["iberobench_en_subtasks"]=${iberobench_en_subtasks[@]}
macro_tasks_lists["portuguese_bench_subtasks"]=${portuguese_bench_subtasks[@]}


for model in ${models[@]}
do
    for num_fewshot in ${num_fewshots[@]}
    do
        for dataset_name in ${datasets[@]}
        do
            if [[ " ${macro_tasks[@]} " =~ " $dataset_name " ]]; then
                subdatasets_list="${macro_tasks_lists[$dataset_name]}"
            else
                subdatasets_list=( $dataset_name )
            fi
            for dataset in ${subdatasets_list[@]}; do
                if [ "$computer" == "cesga" ]; then
                    echo "Running evaluation on Cesga."
                    sed -i "2s/.*/#SBATCH --job-name=\"${job_name}\"/" send_job_${computer}.sh
                    echo $model $dataset $num_fewshot $tensor_parallelism
                    sbatch send_job_cesga.sh $model $dataset $num_fewshot $tensor_parallelism
                elif [ "$computer" == "mn5" ]; then
                    echo "Running evaluation on MN5."  
                    sed -i "2s/.*/#SBATCH --job-name=\"${job_name}\"/" send_job_${computer}.sh
                    sbatch send_job_mn5.sh $model $dataset $num_fewshot $tensor_parallelism
#                     bash send_job_mn5.sh $model $dataset $num_fewshot $tensor_parallelism
                elif [ "$computer" == "polaris" ]; then
                    echo "Running evaluation on Polaris."
                    sed -i "2s/.*/#PBS -N \"${job_name}\"/" send_job_${computer}.sh
                    sed -i "4s~.*~#PBS -o ../logs/${job_name}.out~" send_job_${computer}.sh
                    sed -i "5s~.*~#PBS -e ../logs/${job_name}.err~" send_job_${computer}.sh
                    qsub -v model=$model,dataset=$dataset,num_fewshot=$num_fewshot,tensor_parallelism=$tensor_parallelism send_job_polaris.sh
                elif [ "$computer" == "amd" ]; then
                    echo "Running evaluation on AMD."
                    sed -i "2s/.*/#SBATCH --job-name=\"${job_name}\"/" send_job_${computer}.sh
                    sbatch send_job_amd.sh $model $dataset $num_fewshot $tensor_parallelism
                else
                    echo "The computer name is not known."
                fi
            done
        done
    done
done

