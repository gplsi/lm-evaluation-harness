
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
MODELS_TO_EVALUATE=<<Model name/Model Path>>
HF_TOKEN==<<Hugging face api to access model that requires special permission to execute>>
INSTRUCT_EVALUATION=True #In case you have to evaluate instruction models.
WANDB_PROJECT=<<Project name>>
USER_ID=$(id -u)
GROUP_ID=$(id -g)
```
> In order to evaluate multiple models you can define a list of models separated by commas with no spaces.
Example: `MODELS_TO_EVALUATE=/models/salamandra-2b/iter-167999-ckpt.pth,BSC-LT/salamandraTA-2B,deepseek-ai/DeepSeek-R1`

3. Configure the volumes that you will map to store the *logs*/*results*/*reports* of the container in [docker-compose.yml](./docker-compose.yml).

> In our [docker-compose.yml](./docker-compose.yml) we define a folder named **outputLogs** at the same directory level in which the repo was cloned.

> In addition, in case that you want to use a downloaded model in `/home/NAS/GPLSI` directory, we suggest to use the same directory inside the volume to avoid confusion.

4. Build the image.
```bash
docker build --network=host \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  -t lm-evaluation-harness .
```

5. Execute the container.
```bash
docker compose up
```

>> In case you want to use all the GPUs in the host machine you must set in the [docker-compose.yml](./docker-compose.yml) the **device_ids** to `"all"` in other case you have to introduce manually the device_ids.


The best option is to run the container by using *docker run* command.


```bash
docker run --rm \
  --gpus all  \
  --network host \
  --env CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES}" \
  --env NVIDIA_DRIVER_CAPABILITIES=compute,utility \
  --env WANDB_API_KEY="${WANDB_API_KEY}" \
  --env MODELS_TO_EVALUATE="${MODELS_TO_EVALUATE}" \
  --env HF_TOKEN="${HF_TOKEN}" \
  --env WANDB_PROJECT="${WANDB_PROJECT}" \
  --env USER_ID="${USER_ID}" \
  --env GROUP_ID="${GROUP_ID}" \
  --env INSTRUCT_EVALUATION="${INSTRUCT_EVALUATION}" \
  --volume <<results_path_in_your_machine>>:/app/results \
  --volume <<reports_path_in_your_machine>>:/app/reports \
  --volume <<models_path_in_your_machine>>:/models \
  --volume <<logs_path_in_your_machine>>:/outputLogs \
  --name gplsi_lm-evaluation-harness \
  lm-evaluation-harness
```



## How it works
This container runs a series of tasks corresponding to the spanish bench defined in ['./launch_scripts/execAllScripts.sh]'. The results of the current evaluation are stored in a mounted foulder in the root folder named `./results`.

In addition, there is a mounted folder named `./outputLogs` where the logs of the different evaluation processes will be stored.

In order to modify the tasks that you want to evaluate the models on, you can modify the [./launch_scripts/execAllScripts.sh](./launch_scripts/execAllScripts.sh) which is used as **entrypoint** of the docker container.

After the end of the evaluation a XLSX with the results cleaned will be stored at `./reports` folder, this CSV is generated using [./launch_scripts/format_results.py] that process all the  evaluation results that are stored in  `./results` folder.

>> In case that you want to execute specific tasks we recommend to create a new *script* in [./launch_scripts](./launch_scripts/) directory and modify [./entrypoint.sh](./entrypoint.sh) to call the custom script instead of [./launch_scripts/execAllScripts.sh](./launch_scripts/execAllScripts.sh).

## SLURM
In order to deploy the docker container in **SLURM**  is an open-source job scheduler used for managing workloads on high-performance computing (HPC) clusters. It is responsible for allocating compute resources, scheduling jobs, and managing parallel execution across multiple nodes.

To use our application with this framework we define a **Slurm configuration file** [p1.slurm](./p1.slurm), in which we built
the image and launch the container that will invoke the evaluation of the LLM. This scripts perform the following actions:


1. Checks the GPUs available.
2. Performs a stop and remove command for the `gplsi_lm-evaluation-harness` in case there is a *zombie* container that keeps running after stoping a failed slurm job.
3. Builds our lm-evaluation-harness custom Docker image.
4. Runs the container.

>> In case that you launch different jobs evaluation, you will have to modify the [p1.slurm](./p1.slurm) assigning different names to the container and removing the stop and remove command in order to avoid to stopping the container.

Inside this configuration file we define different params:
- `#SBATCH --job-name=llm_evaluation_harness `: Name of the job to be launched.  
- `#SBATCH --output=%j.out `: Name of the output files. *In this case, they are defined as <<id_job>>.out*  
- `#SBATCH --error=%j.err`: Name of the error files. *In this case, they are defined as <<id_job>>.err*  
- `#SBATCH --cpus-per-task=16`: Number of CPUs per task.  
- `#SBATCH --mem=32G`: Memory per node.  
- `#SBATCH --partition=<<queue-name>>`: Queue to which the job is submitted.  
- `#SBATCH --gres=gpu:2`: Requests 2 GPUs for execution.  



### Launch SLUM

To launch the SLUM job you must be located in the project root directory and execute the following command.

```bash
sbatch p1.slurm
```

To stop a launched job.

```bash
scancel <<jobid>>
```

To see the running jobs.
```bash
scancel <<jobid>>
```

>> We recommend to launch this job inside the *postiguet* SLURM queue.

