#!/usr/bin/env python3
"""Download evaluation datasets into a specified cache directory."""

import argparse
from datasets import load_dataset

DATASETS = [
    {"repo": "facebook/belebele", "name": "cat_Latn"},
    {"repo": "projecte-aina/xnli-ca", "name": None},
    {"repo": "nbel/CatCoLA", "name": None},
    {"repo": "projecte-aina/COPA-ca", "name": None},
    {"repo": "projecte-aina/openbookqa_ca", "name": None},
    {"repo": "projecte-aina/PAWS-ca", "name": None},
    {"repo": "projecte-aina/piqa_ca", "name": None},
    {"repo": "projecte-aina/teca", "name": None},
    {"repo": "projecte-aina/wnli-ca", "name": None},
    {"repo": "projecte-aina/arc_ca", "name": "ARC-Easy"},
    {"repo": "projecte-aina/arc_ca", "name": "ARC-Challenge"},
    {"repo": "projecte-aina/xstorycloze_ca", "name": "ca"},
    {"repo": "projecte-aina/siqa_ca", "name": None},
    {"repo": "projecte-aina/catalanqa", "name": None},
    {"repo": "projecte-aina/mgsm_ca", "name": None},
    {"repo": "projecte-aina/xquad-ca", "name": None},
    {"repo": "projecte-aina/caBreu", "name": None},
    {"repo": "facebook/belebele", "name": "eng_Latn"},
    {"repo": "facebook/belebele", "name": "spa_Latn"},
    {"repo": "juletxara/xstory_cloze", "name": "en"},
    {"repo": "juletxara/xstory_cloze", "name": "es"},
    {"repo": "xnli", "name": "en"},
    {"repo": "xnli", "name": "es"},
    {"repo": "trivia_qa", "name": "rc.nocontext"},
    {"repo": "paws-x", "name": "en"},
    {"repo": "paws-x", "name": "es"},
    {"repo": "EleutherAI/coqa", "name": None},
    {"repo": "baber/piqa", "name": None},
    {"repo": "juletxara/mgsm", "name": "en"},
    {"repo": "juletxara/mgsm", "name": "es"},
    {"repo": "nyu-mll/glue", "name": "cola"},
    {"repo": "nyu-mll/glue", "name": "wnli"},
    {"repo": "openbookqa", "name": "main"},
    {"repo": "allenai/ai2_arc", "name": "ARC-Easy"},
    {"repo": "allenai/ai2_arc", "name": "ARC-Challenge"},
    {"repo": "social_i_qa", "name": None},
    {"repo": "PlanTL-GOB-ES/wnli-es", "name": None},
    {"repo": "xquad", "name": "xquad.es"},
    {"repo": "gplsi/cocoteros", "name": None},
    {"repo": "csebuetnlp/xlsum", "name": "spanish"},
    {"repo": "BSC-LT/openbookqa-es", "name": None},
    {"repo": "nbel/EsCoLA", "name": None},
    {"repo": "BSC-LT/COPA-es", "name": None},
    {"repo": "gplsi/cocoteros_va", "name": None},
    {"repo": "gplsi/xnli_va", "name": None},
    {"repo": "gplsi/truthfulqa_va", "name": "generation"},
    {"repo": "gplsi/ES-VA_translation_test", "name": None},
    {"repo": "gplsi/CA-VA_alignment_test", "name": None},
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download datasets used by Catalan benchmark tasks."
    )
    parser.add_argument(
        "--cache-dir",
        required=True,
        help="Directory where datasets will be cached.",
    )
    parser.add_argument(
        "--only",
        nargs="*",
        default=None,
        help=(
            "Optional list of dataset repos to download (e.g., projecte-aina/teca)."
        ),
    )
    return parser.parse_args()


def should_download(repo: str, only_list: list[str] | None) -> bool:
    if not only_list:
        return True
    return repo in only_list


def main() -> None:
    args = parse_args()
    failed: list[tuple[str, str | None]] = []

    for item in DATASETS:
        repo = item["repo"]
        name = item["name"]

        if not should_download(repo, args.only):
            continue

        try:
            if name:
                print(f"Downloading {repo} ({name})...")
                load_dataset(repo, name, cache_dir=args.cache_dir)
            else:
                print(f"Downloading {repo}...")
                load_dataset(repo, cache_dir=args.cache_dir)
        except Exception as exc:
            failed.append((repo, name))
            print(f"Failed: {repo} ({name}) -> {exc}")

    if failed:
        print("\nDownload failures:")
        for repo, name in failed:
            if name:
                print(f"- {repo} ({name})")
            else:
                print(f"- {repo}")
    else:
        print("\nAll downloads completed successfully.")


if __name__ == "__main__":
    main()
