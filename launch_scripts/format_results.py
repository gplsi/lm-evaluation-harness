import os
import json
import pandas as pd
import re
from datetime import datetime
 
 
def extract_results_from_json(file_path):
    """
    Lee un JSON y devuelve un diccionario con:
    - 'results' (las tareas)
    - 'execution_datetime' (fecha/hora extraída del nombre de archivo y convertida a datetime)
    """
    print(f"      📄 Leyendo JSON: {file_path}")  
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
 
    results = data.get("results", {})  
    print(f"        🔹 {len(results)} tareas encontradas en el JSON")
 
    # Extraer fecha/hora desde el nombre de archivo
    match = re.search(r'results_(\d{4}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2}\.\d+)\.json', os.path.basename(file_path))
    if match:
        date_str = match.group(1)
        # Convertir el string a formato ISO (reemplazando los guiones de la hora por dos puntos)
        date_str_fixed = re.sub(r'T(\d{2})-(\d{2})-(\d{2})', r'T\1:\2:\3', date_str)
        execution_datetime = datetime.fromisoformat(date_str_fixed)
    else:
        execution_datetime = None
 
    return {
        "results": results,
        "execution_datetime": execution_datetime
    }
 
 
def extract_all_data(root_folder):
    """
    Recorre todas las carpetas dentro de 'root_folder', busca subcarpetas (nivel 2),
    y extrae las tareas de los archivos JSON dentro del nivel 3, agregando la fecha de ejecución a cada tarea.
    """
    all_data = {}
 
    for model_folder in os.listdir(root_folder):
        print("📂 Explorando modelo:", model_folder)
        model_path = os.path.join(root_folder, model_folder)
 
        if os.path.isdir(model_path):
            for results_folder in os.listdir(model_path):
                results_path = os.path.join(model_path, results_folder)
 
                if os.path.isdir(results_path):
                    print(f"  📁 Explorando resultados: {results_folder}")
                    folder_data = []
 
                    for filename in os.listdir(results_path):
                        if filename.startswith("results_") and filename.endswith(".json"):
                            file_path = os.path.join(results_path, filename)
                            json_data = extract_results_from_json(file_path)
 
                            results = json_data["results"]
                            execution_datetime = json_data["execution_datetime"]
 
                            # Inyectar la fecha de ejecución dentro de cada tarea
                            for task_name in results:
                                results[task_name]["execution_datetime"] = execution_datetime
 
                            folder_data.append(results)
 
                    if folder_data:
                        if model_folder not in all_data:
                            all_data[model_folder] = []
                        all_data[model_folder].extend(folder_data)
 
    return all_data
 
 
def convert_results_to_dataframe(results_dict):
    """
    Convierte un diccionario de resultados en un DataFrame.
    """
    print("\n📊 Convirtiendo resultados a DataFrame...")
    all_data = []
 
    for model_name, tasks_list in results_dict.items():
        print(f"  📄 Modelo: {model_name} ({len(tasks_list)} archivos JSON)")
 
        for tasks_dict in tasks_list:
            for task_name, metrics in tasks_dict.items():
                task_data = {"model": model_name, "task": task_name}
                for metric_name, metric_value in metrics.items():
                    if metric_name != "alias":
                        task_data[metric_name] = metric_value
                all_data.append(task_data)
 
    df = pd.DataFrame(all_data)
    print(f"✅ DataFrame creado con {df.shape[0]} filas y {df.shape[1]} columnas.")
    return df
 
 
def process_all_folders(main_root_folder):
    """
    Recorre todas las carpetas dentro de `main_root_folder`,
    extrae los datos y los convierte en un solo DataFrame,
    agregando columna `root_folder` y ordenando las columnas.
    """
    print("\n🚀 Iniciando procesamiento de carpetas...")
    all_dfs = []
 
    for root_folder in os.listdir(main_root_folder):
        root_path = os.path.join(main_root_folder, root_folder)
 
        if os.path.isdir(root_path):
            print(f"\n📂 🔍 Procesando carpeta raíz: {root_folder}")
 
            data_dict = extract_all_data(root_path)
            df_results = convert_results_to_dataframe(data_dict)
 
            if not df_results.empty:
                df_results["root_folder"] = root_folder
                all_dfs.append(df_results)
 
    if all_dfs:
        final_df = pd.concat(all_dfs, ignore_index=True, sort=False)
        print(f"\n✅ DataFrame final con {len(final_df)} filas y {len(final_df.columns)} columnas.")
    else:
        final_df = pd.DataFrame()
        print("❌ No se encontraron datos válidos.")
 
    # Reordenar columnas poniendo root_folder y execution_datetime al inicio si están presentes
    cols = final_df.columns.tolist()
    for col in ["root_folder", "execution_datetime"]:
        if col in cols:
            cols.insert(0, cols.pop(cols.index(col)))
    final_df = final_df[cols]
    return final_df



main_root_folder = "../results"  # 🔹 Cambia esto por la ruta real
df_final = process_all_folders(main_root_folder)
current_datetime = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
filename = f"../reports/results_cleaned_{current_datetime}.csv"
df_final.to_csv(filename, index=False)
print(f"\n✅ Archivo guardado como {filename}")