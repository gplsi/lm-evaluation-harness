import numpy as np
from sklearn.metrics import f1_score

import random
import os

import pandas as pd





def process_docs(dataset):
    TRAIN_FILE = "/home/gplsi/santi/translate_datasets/cieacova/multiple-choice-train.parquet"
    df_train = pd.read_parquet(TRAIN_FILE)
    # Filtramos posibles nulos en la instrucción al crear el diccionario
    df_train = df_train.dropna(subset=["Instrucción"])
    INSTRUCCION_MAP = df_train.drop_duplicates(subset=["Instrucción"]).set_index("Instrucción").to_dict(orient="index")
    def _process_doc(doc):
        # 1. Extracción segura de Opciones (evitando que rompa si es None)
        opciones_brutas = doc.get("Opciones")
        if opciones_brutas is None:
            opciones = [""]
        elif isinstance(opciones_brutas, str):
            opciones = [opt.strip() for opt in opciones_brutas.strip("[]").split(",") if opt.strip()]
        else:
            opciones = list(opciones_brutas) # Si ya es una lista
            
        # 2. Extracción segura de Respuestas
        respuesta_bruta = doc.get("Respuesta")
        if respuesta_bruta is None:
            respuestas = [""]
        elif isinstance(respuesta_bruta, str):
            respuestas = [ans.strip() for ans in respuesta_bruta.strip("[]").split(",") if ans.strip()]
        else:
            respuestas = list(respuesta_bruta)

        # 3. Cálculo de índices seguro
        correct_indices = [opciones.index(ans) for ans in respuestas if ans in opciones]
        if not correct_indices: 
            correct_indices = [0]
        
        doc["parsed_opciones"] = opciones
        doc["parsed_respuesta"] = correct_indices

        # 4. Inyección del Few-Shot Único
        inst_actual = doc.get("Instrucción")
        
        # Verificamos que la instrucción no sea None y exista en nuestro mapa
        if inst_actual and inst_actual in INSTRUCCION_MAP:
            ej = INSTRUCCION_MAP[inst_actual]
            doc["dynamic_fewshot"] = (
                f"Exemple de Text a resoldre:\n{ej.get('Pregunta', '')}\n\n"
                f"Exemple Opcions de resposta:\n{ej.get('Opciones', '')}\n\n"
                f"Exemple Resposta:\n{ej.get('Respuesta', '')[0]}\n\n"
                f"---\n\n"
            )
        else:
            doc["dynamic_fewshot"] = "ERROR: Instrucción no encontrada para few-shot."

        return doc

    return dataset.map(_process_doc)


def process_results(doc, results):
    """
    Toma los resultados brutos del modelo y calcula acc y acc_norm.
    """
    lls = [res[0] if isinstance(res, tuple) else res for res in results]
    
    opciones = doc["parsed_opciones"]
    
    lls_norm = [ll / max(1, len(opt)) for ll, opt in zip(lls, opciones)]
    
    pred = np.argmax(lls)             # Predicción bruta
    pred_norm = np.argmax(lls_norm)   # Predicción normalizada
    
    targets = doc["parsed_respuesta"]
    
    acc = 1.0 if pred in targets else 0.0
    acc_norm = 1.0 if pred_norm in targets else 0.0
    
    dificultad = doc.get("Metadata", {}).get("Dificultad", "Desconocida")
    
    return {
        "acc": acc,
        "acc_norm": acc_norm,
        f"acc_{dificultad}": acc,
        f"acc_norm_{dificultad}": acc_norm
    }




def process_gen_docs(dataset):
    TRAIN_FILE = "/home/gplsi/santi/translate_datasets/cieacova/text-generation-train.parquet"
    df_train = pd.read_parquet(TRAIN_FILE)
    # Filtramos posibles nulos en la instrucción al crear el diccionario
    df_train = df_train.dropna(subset=["Instrucción"])
    INSTRUCCION_MAP = df_train.drop_duplicates(subset=["Instrucción"]).set_index("Instrucción").to_dict(orient="index")
    def _process_doc(doc):
        respuesta_str = doc.get("Respuesta", "")
        
        # Si viene como un string tipo "[opcion1, opcion2]"
        if isinstance(respuesta_str, str):
            # Quitamos los corchetes, separamos por comas y limpiamos comillas/espacios
            respuestas = [
                ans.strip().strip("'\"") 
                for ans in respuesta_str.strip("[]").split(",") 
                if ans.strip()
            ]
        else:
            # Si ya era una lista real de Python
            respuestas = respuesta_str
            
        # Guardamos la lista limpia para usarla como target
        doc["parsed_respuesta"] = respuestas
        doc['rules'] = (f"Regles:\n"
        f"- Segueix la descripció de la tasca de forma precisa.\n" 
        f"- Utilitza el text d’entrada com principal font d’informació.\n" 
        f"- Utilitza la pista únicament si és rellevant per a la tasca.\n" 
        f"- Produeix una resposta que siga completa, coherent i que responga directament a la tasca.\n"
        f"- El llenguatge i estil de la resposta han de ser iguals que el de la instrucció.\n\n")






        # 4. Inyección del Few-Shot Único
        inst_actual = doc.get("Instrucción")
        
        # Verificamos que la instrucción no sea None y exista en nuestro mapa
        if inst_actual and inst_actual in INSTRUCCION_MAP:
            ej = INSTRUCCION_MAP[inst_actual]
            pista = ej.get('Pista', '')
            pista_section = f"Exemple PISTA:\n{pista}\n\n" if pista else ""
            doc["dynamic_fewshot"] = (
                f"Exemple de Text a resoldre:\n{ej.get('Pregunta', '')}\n\n"
                f"{pista_section}"
                f"Exemple Resposta:\n{ej.get('Respuesta', '')[0]}\n\n"
                f"---\n\n"
            )
        else:
            doc["dynamic_fewshot"] = "ERROR: Instrucción no encontrada para few-shot."

        return doc

    return dataset.map(_process_doc)


def clean_text(text, allowed_specials):
        if not text: return ""
        return ''.join(
            c.lower() for c in text 
            if c.isalnum() or c in allowed_specials
        ).strip()

def process_results_text_generation(doc, results):
    """
    Procesa los resultados de generación de texto.
    """



    pred = results[0] if isinstance(results, list) else results
    targets = doc["parsed_respuesta"]


    # 2. Dynamic Character Analysis
    allowed_specials = {
        char for t in targets 
        for char in t 
        if not char.isalnum() and not char.isspace()
    }
    
    # Comprobamos si la predicción está en los targets (ignorando mayúsculas y puntuación)
    pred_clean = clean_text(pred, allowed_specials)
    targets_clean = [clean_text(t, allowed_specials) for t in targets]
    
    acc = 1.0 if pred_clean in targets_clean else 0.0
    
    dificultad = doc.get("Metadata", {}).get("Dificultad", "Desconocida")
    
    return {
        "exact_match": acc,
        f"exact_match_{dificultad}": acc
    }