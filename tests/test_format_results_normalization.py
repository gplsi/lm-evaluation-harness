import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from launch_scripts.format_results import normalized_value


def test_normalized_value_scales_probability_metrics():
    row = {
        "metric": "acc",
        "model_a": 0.73,
        "random": 33.33,
        "Max": 100,
    }

    value = normalized_value(row, "model_a")

    assert round(value, 4) == round((73 - 33.33) / (100 - 33.33), 4)


def test_normalized_value_keeps_truthfulqa_percentage_metrics():
    row = {
        "metric": "bleu_max",
        "model_a": 42.0,
        "random": 0,
        "Max": 100,
    }

    value = normalized_value(row, "model_a")

    assert value == 0.42
