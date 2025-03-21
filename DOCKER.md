
# Docker Setup

## Purpose  
This branch of [lm-evaluation-harness]() is designed to build a *Docker* image of the framework, enabling parameterized evaluation of models in `IberoBench`. The `IberoBench` evaluation consists of four task groups:

- **spanish_bench**: Tasks in Spanish.  
- **catalan_bench**: Tasks in Catalan.  
- **galician_bench**: Tasks in Galician.  
- **basque_bench**: Tasks in Basque.  

This setup allows for streamlined and reproducible model evaluation across different linguistic benchmarks.

> At this moment the docker container only launches the task corresponding to *spanish*,*catalan* and *english* tasks.

## Configuration

In order to use [lm-evaluation-harness] inside a docker container, you have to follow this steps.

1. Clone the repository and switch to branch docker.

```
git clone https://github.com/gplsi/lm-evaluation-harness.git
```

2. Create the `.env` in which different configurations(*model-name*,*model-path*,*wandb-configuration*) will be set.
```.env
WANDB_API_KEY=<<WANDB api key>>
MODEL_ID_HUGGING_FACE=<<Model name/Model Path>>
WANDB_PROJECT=<<Project name>>
```

3. Configure the volume that you will use to store the *logs*/*results*/*reports* of the container in [docker-compose.yml](./docker-compose.yml).

> In our [docker-compose.yml](./docker-compose.yml) we define a folder named **outputLogs** at the same directory level in which the repo was cloned.

4. Build the image.
```bash
docker build --network=host  -t lm-evaluation-harness .
```

5. Execute the container.
```bash
docker compose up
```

>> In case you want to use all the GPUs in the host machine you must set in the [docker-compose.yml](./docker-compose.yml) the **device_ids** to `"all"` in other case you have to introduce manually the device_ids.


## How it works
This container runs a series of tasks corresponding to the spanish bench. The results of the evaluation is presented in the mounted foulder in the root folder named `./results`.

In addition, there is a mounted folder named `./outputLogs` where the logs of the different evaluation processes will be stored.

In order to modify the tasks that you want to evaluate the models on, you can modify the [./launch_scripts/execAllScripts.sh](./launch_scripts/execAllScripts.sh) which is used as **entrypoint** of the docker container.

A CSV with the results cleaned will be stored at `./reports` folder, this CSV is generated using [./launch_scripts/format_results.py] that process all the  evaluation results that are stored in  `./results` folder.

## SLURM
In order to deploy the docker container in **SLURM**  is an open-source job scheduler used for managing workloads on high-performance computing (HPC) clusters. It is responsible for allocating compute resources, scheduling jobs, and managing parallel execution across multiple nodes.

To use our application with this framework we define a **simple slurm configuration** [p1.slurm](./p1.slurm).

Inside this configuration file we define different params:
- `#SBATCH --job-name=llm_evaluation_harness `: Name of the job to be launched.  
- `#SBATCH --output=%j.out `: Name of the output files. *In this case, they are defined as <<id_job>>.out*  
- `#SBATCH --error=%j.err`: Name of the error files. *In this case, they are defined as <<id_job>>.err*  
- `#SBATCH --cpus-per-task=1 `: Number of CPUs per task.  
- `#SBATCH --mem=1G`: Memory per node.  
- `#SBATCH --partition=<<queue-name>>`: Queue to which the job is submitted.  
- `#SBATCH --gres=gpu:2`: Requests 2 GPUs for execution.  
- `#SBATCH --gres=shard:24`: Requests 24 shards of shared memory.  

### Launch SLUM

To launch the SLUM job you must be located in the project root directory and execute the following command.

```bash
sbatch p1.slurm
```


