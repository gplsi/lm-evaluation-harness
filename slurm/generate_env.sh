#!/usr/bin/env python3
# filepath: /home/gplsi/Documentos/ALIA/lm-evaluation-harness/generate_env.py

import argparse
import os
import yaml
import re
import uuid
from pathlib import Path

def parse_arguments():
    parser = argparse.ArgumentParser(description="Generate environment file from YAML configuration")
    parser.add_argument("--config", type=str, required=True, help="Path to the YAML configuration file")
    parser.add_argument("--output", type=str, help="Path to output env file (defaults to .env_<unique_id>_<experiment_name>)")
    return parser.parse_args()

def read_config(config_path):
    with open(config_path, 'r') as file:
        return yaml.safe_load(file)

def sanitize_filename(name):
    """Convert a string to a valid filename by removing invalid characters"""
    return re.sub(r'[^a-zA-Z0-9_-]', '_', name)


def generate_env_file(config, output_path=None):
    # Generate unique identifier
    unique_id = str(uuid.uuid4())[:8]
    
    # Use evaluation_name for the experiment name
    experiment_name = sanitize_filename(config['evaluation_name'])
    
    # If output path not specified, create one with unique ID and experiment name
    if not output_path:
        output_path = f".env_{unique_id}_{experiment_name}"
    
    # Get user and group ID (needed for docker)
    user_id = os.getuid()
    group_id = os.getgid()
    
    # Parse model names
    models_names = config['models']['models_names'].replace(',', ' ')
    
    # Create the env file content
    env_content = [
        f"USER_ID={user_id}",
        f"GROUP_ID={group_id}",
        f"MODELS_TO_EVALUATE={models_names}",
        f"MODELS_FOLDER={config['models']['models_path']}",
        f"EVALUATION_FOLDER={config['evaluation']['evaluation_folder']}",
        f"EVALUATION_FOLDER_GOLD={config['evaluation']['evaluation_folder_gold']}",
        f"WANDB_PROJECT={config['wandb_project']}",
        f"INSTRUCT_EVALUATION={str(config['evaluation']['instruct']).capitalize()}",
        f"SHOTS={config['evaluation']['shots']}",
        # Read sensitive tokens from environment if available
        f"WANDB_API_KEY={os.environ.get('WANDB_API_KEY', '')}",
        f"HF_TOKEN={os.environ.get('HF_TOKEN', '')}"
    ]
    
    # Write the env file
    env_file = Path(output_path)
    env_file.write_text("\n".join(env_content))
    
    return env_file

def check_model_configuration(config):
    """Check if the model configuration is valid"""
    required_fields = ['local', 'models_names', 'models_path']

    for field in required_fields:
        if field not in config['models']:
            raise ValueError(f"Missing required field in models configuration: {field}")

    if config['models']['local'] == False:
        print("Using models from Hugging Face")
        pass
    else:
        models_names = config['models']['models_names'].split(',')
        models_path = Path(config['models']['models_path'])
        if not models_path.exists():
            raise ValueError(f"Models path does not exist: {models_path}")

        # Check if all specified models exist in the models path
        for model_name in models_names:
            model_name = model_name.strip()
            model_path = models_path +'/'+ model_name
            if not model_path.exists():
                raise ValueError(f"Model not found in models path: {model_path}")

def check_evaluation_configuration(config):
    """Check if the evaluation configuration is valid"""
    # Check if evaluation configuration has all required fields
    required_fields = ['evaluation_folder', 'evaluation_folder_gold','instruct','shots']
    for field in required_fields:
        if field not in config['evaluation']:
            raise ValueError(f"Missing required field in evaluation configuration: {field}")
    
    # Check if instruct evaluation is a boolean and shots is a non-negative integer
    if config['evaluation']['instruct'] not in [True, False]:
        raise ValueError("Instruct evaluation must be a boolean value (True or False)")
    # Check if shots is a non-negative integer
    if not isinstance(config['evaluation']['shots'], int) or config['evaluation']['shots'] < 0:
        raise ValueError("Shots must be a non-negative integer")
    

def check_languages_configuration(config):
    """Check if the languages configuration is valid"""
    if 'languages' not in config or not isinstance(config['languages'], list):
        raise ValueError("Languages configuration must be a list of language objects")
    
    supported_languages = ['Spanish', 'English', 'Valencian', 'Catalan']
    
    for lang_obj in config['languages']:
        if not isinstance(lang_obj, dict):
            raise ValueError("Each language entry must be a dictionary")
        
        for lang_name, enabled in lang_obj.items():
            if lang_name not in supported_languages:
                raise ValueError(f"Unsupported language: {lang_name}. Supported languages are: {supported_languages}")
            
            if not isinstance(enabled, bool):
                raise ValueError(f"Language '{lang_name}' value must be a boolean (true/false)")
        
def check_config(config):
    """Check if the config has all required fields"""
    required_fields = [
        'models', 'evaluation','languages' 
    ]
    for field in required_fields:
        if field not in config:
            raise ValueError(f"Missing required field in config: {field}")
    
    # Check models configuration
    check_model_configuration(config)
    check_evaluation_configuration(config)
    check_languages_configuration(config)
    
    if 'evaluation_folder' not in config['evaluation'] or 'evaluation_folder_gold' not in config['evaluation']:
        raise ValueError("Missing evaluation folder paths in evaluation configuration")

def main():
    args = parse_arguments()
    config = read_config(args.config)
    check_config(config)
    print(f"Generating environment file for: {config['evaluation_name']}")
    
    # Generate environment file from config
    env_file = generate_env_file(config, args.output)
    
    print(f"Environment file created: {env_file}")
    print(f"You can now run: bash launch_job.sh {env_file}")
    
if __name__ == "__main__":
    main()