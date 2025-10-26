# 🧩 Analizador UML con OCL

Este proyecto implementa un **analizador léxico y sintáctico** para modelos UML con expresiones OCL (*Object Constraint Language*), desarrollado con **Flex** y **Bison**.  
El objetivo es validar la estructura y las restricciones de modelos UML escritos en formato textual, detectando errores léxicos y sintácticos.

---

## ⚙️ Componentes principales

- **`ocl.l`** → Analizador léxico (Flex)  
  Se encarga de identificar los tokens del lenguaje: identificadores, tipos, operadores, literales, palabras clave OCL, etc.

- **`ocl.y`** → Analizador sintáctico (Bison)  
  Define las reglas gramaticales para validar modelos UML y expresiones OCL (invariantes, precondiciones, postcondiciones, etc.).

- **`Makefile`** → Automatiza el proceso de compilación y limpieza de los ejecutables generados.

---

## 🧱 Estructura del proyecto

📂 uml-ocl-parser/
┣ 📜 ocl.l # Analizador léxico (Flex)
┣ 📜 ocl.y # Analizador sintáctico (Bison)
┣ 📜 Makefile # Compilación y limpieza automática
┣ 📂 inputs/ # Archivos de prueba (.ocl)
┗ 📘 README.md # Documentación del proyecto

---

## 🔧 Compilación

Para compilar el analizador:

```bash
make
```

Para limpiar los archivos generados:

```bash
make clean
```
---

## ▶️ Ejecución

Una vez compilado, el analizador puede ejecutarse de dos formas:

### 💻 Modo terminal
```bash
./compiler.out
```

Analiza la entrada estándar del usuario (introduciendo texto OCL directamente).

### 📁 Modo fichero
```bash
./compiler.out <rutaFichero>
```

Ejemplo:
```bash
./compiler.out ./inputs/modelo-ejemplo.ocl
```

---

## 🧪 Archivos de prueba

El proyecto incluye 10 archivos de entrada ubicados en la carpeta inputs/:

- 6 archivos oficiales proporcionados por la asignatura (para pruebas sintácticas).

- 3 archivos válidos adicionales, creados para verificar casos correctos.

- 1 archivo con errores personalizados, diseñado para comprobar la detección de fallos.

---

## 🧠 Funcionamiento del analizador

**1.** El analizador léxico (ocl.l) procesa la entrada y genera tokens que describen los elementos básicos del lenguaje.

**2.** El analizador sintáctico (ocl.y) recibe esos tokens y aplica las reglas gramaticales definidas para construir el modelo.

**3.** Si se detectan más de 10 errores sintácticos, el análisis se detiene.

**4.** Si no hay errores, se muestra que el archivo OCL es sintácticamente correcto y apto para una fase semántica posterior.

---

## 🧰 Tecnologías utilizadas

- Flex – Generador de analizadores léxicos

- Bison (Yacc) – Generador de analizadores sintácticos

- Makefile – Automatización de compilación y limpieza

- C – Lenguaje de implementación base

## ✨ Aprendizaje

Con este proyecto aprendí a:

- Diseñar un lenguaje formal con gramática libre de contexto.

- Implementar analizadores léxicos y sintácticos cooperando entre sí.

- Gestionar errores y controlar la recuperación tras fallos léxicos o sintácticos.

- Automatizar el proceso de compilación mediante Makefiles.

👥 Autores

- Marcos Alonso Ulloa (@Marcau04)
- Marcos Cámara Vicente
- Marcos Alonso Ulloa
