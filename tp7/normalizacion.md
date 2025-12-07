## Anomalías:

- **Inserción**: un registro de datos no se puede insertar en una tabla porque tiene missing values requeridos por una o más columnas de la tabla.
- **Borrado**: la eliminación de un registro resulta en la eliminación involuntaria de datos importantes incluidos en dicho registro.
- **Actualización**: una instancia de datos se actualiza en una ubicación de una base de datos, pero en otras ubicaciones no. 
## Algoritmos de Clase
### Clausura de un Conjunto de Atributos
Si **X** es un conjunto de atributos de **R**, la clausura de **X**, denotada con $X^+$, respecto del conjunto de dependencias de F de dicho esquema, es el conjunto de atributos determinados por **X** a través de las dependencias de $F^+$: $X^+=\{A/X \rightarrow A \in F^+ \}$  

> No está a la **derecha de nadie** -> pertenecen a toda clave y cuando lo pongo llego a R evito tener que buscarle subconjuntos adentro.

### Dependencias Funcionales (FDs) 

El concepto central de la teoría de normalización son las **dependencias funcionales**. Son restricciones que se establecen entre dos conjuntos de atributos de una tabla.

#### **Definición: Dependencia Funcional**

Sean X e Y dos conjuntos de atributos de un esquema de relación R. Se dice que **X determina funcionalmente a Y** (o que Y depende funcionalmente de X), y se denota como X→Y, si para cualquier par de tuplas t1​ y t2​ de una instancia r de R, se cumple que:

Si t1​[X]=t2​[X], entonces t1​[Y]=t2​[Y]
## Anomalías en Bases de Datos No Normalizadas

Las anomalías son problemas que pueden surgir en bases de datos mal diseñadas o no normalizadas:

- **Anomalía de inserción**: No se puede insertar un registro porque faltan valores requeridos por una o más columnas.
- **Anomalía de borrado**: Al eliminar un registro, se pierden datos importantes que solo estaban presentes en ese registro.
- **Anomalía de actualización**: Al modificar un dato en una ubicación, ese mismo dato puede quedar desactualizado en otras ubicaciones donde aparece duplicado.

---
**Dependencia Funcional Trivial**: Una dependencia funcional X→Y es **trivial** si y solo si Y⊆X.

---

### Axiomas de Armstrong y Reglas de Inferencia 

## Conceptos Fundamentales de Normalización

### Dependencias Funcionales (FDs)

El concepto central de la teoría de normalización son las **dependencias funcionales**. Son restricciones entre dos conjuntos de atributos de una tabla.

**Definición:** Sean $X$ e $Y$ dos conjuntos de atributos de un esquema de relación $R$. Se dice que **X determina funcionalmente a Y** (o que Y depende funcionalmente de X), y se denota como $X \rightarrow Y$, si para cualquier par de tuplas $t_1$ y $t_2$ de una instancia $r$ de $R$, se cumple que:

Si $t_1[X] = t_2[X]$, entonces $t_1[Y] = t_2[Y]$.

Esto significa que un valor para el conjunto de atributos $X$ tiene asociado exactamente un valor para el conjunto de atributos $Y$.

**Dependencia Funcional Trivial:** $X \rightarrow Y$ es trivial si y solo si $Y \subseteq X$.

---


### Axiomas de Armstrong y Reglas de Inferencia

Para deducir todas las dependencias funcionales posibles a partir de un conjunto inicial $F$, se utilizan los **Axiomas de Armstrong**, que son correctos (no generan dependencias inválidas) y completos (pueden generar todas las dependencias válidas).

**Axiomas de Armstrong:**
- **Reflexividad:** Si $Y \subseteq X$, entonces $X \rightarrow Y$.
- **Aumentación:** Si $X \rightarrow Y$, entonces $XZ \rightarrow YZ$.
- **Transitividad:** Si $X \rightarrow Y$ y $Y \rightarrow Z$, entonces $X \rightarrow Z$.

**Reglas derivadas:**
- **Unión:** Si $X \rightarrow Y$ y $X \rightarrow Z$, entonces $X \rightarrow YZ$.
- **Descomposición:** Si $X \rightarrow YZ$, entonces $X \rightarrow Y$ y $X \rightarrow Z$.
- **Pseudo-transitividad:** Si $X \rightarrow Y$ y $WY \rightarrow Z$, entonces $WX \rightarrow Z$.

---

### Clausura de un Conjunto de Atributos

La **clausura de $X$** respecto del conjunto de dependencias $F$ (denotada $X^+$) es el conjunto de todos los atributos que pueden ser determinados funcionalmente por $X$ usando las dependencias de $F^+$:

$$X^+ = \{A \mid X \rightarrow A \in F^+\}$$

**Algoritmo para calcular $X^+$:**
1. Inicializar $X^+$ con $X$.
2. Mientras $X^+$ siga creciendo:
    - Para cada dependencia funcional $Y \rightarrow Z$ en $F$:
        - Si $Y \subseteq X^+$, agregar $Z$ a $X^+$.
3. Repetir hasta que $X^+$ no cambie.

---
- **R2: Pseudo Transitividad**: Si X→Y y WY→Z, entonces WX→Z.
- **R3: Descomposición**: Si X→YZ, entonces X→Y y X→Z.
    

---

### Clausura de Atributos y Algoritmos 

Calcular la clausura completa de un conjunto de dependencias (F+) es computacionalmente muy costoso. En la práctica, es más útil resolver si una dependencia específica pertenece a la clausura. Para ello, se utiliza el concepto de **clausura de un conjunto de atributos** y un algoritmo eficiente para calcularla.

#### **Definición: Clausura de un Conjunto de Atributos**

Dado un conjunto de atributos X y un conjunto de dependencias funcionales F, la **clausura de X** (denotada como X+) es el conjunto de todos los atributos A que son funcionalmente determinados por X bajo F.
$$X^+=\{A/X \rightarrow A \in F^+ \}$$

Un uso fundamental de este concepto es que permite verificar si una dependencia X→Y se cumple, simplemente comprobando si Y⊆X+. También es clave para encontrar las claves candidatas de una relación: si X+ contiene todos los atributos del esquema R, entonces X es una superclave.

#### **Algoritmo para Calcular la Clausura de Atributos X+**

Este algoritmo tiene complejidad temporal lineal y es la herramienta fundamental para los ejercicios teóricos de normalización.

**Pseudo-código:**
Inicializar X+ con X
```
while (X+ sufra cambios)
	for (cada dependencia funcional Y -> Z en F)
		if (Y incluido X+)
			agregarle Z a X+
```

### Condición de Descomposición sin Pérdida para Dos Esquemas

$$ (R1 \cap R2) \rightarrow R1 - R2 \in F+ $$
$$ o\ bien $$
$$ (R1 \cap R2) \rightarrow R2 - R1 \in F+ $$
#### ¿Y si fueran N Esquemas?
Para determinar si la descomposición en más de dos esquemas tiene o no pérdida de información hay que usar una matriz especial denominada **tableu**.


$$
f(x)= \left\{ \begin{array}{lcc} aj\ si\ Ri\ contiene\ al\ atributo\ Aj \\ \\ bij\ si\ Ri\ no\ contiene\ al\ atributo\ Aj \end{array} \right.
$$
Si llego a una fila donde todas las variables son distinguidas (aj) $\Rightarrow$ no hay pérdida de información
### Algoritmo para calcular la proyección final de F+ sobre un subesquema de R

precondicion: dejar a la derecha en F solo un elemento

Algoritmo de Gottlob:

```c
// Inicialización
Sea R el esquema de dependencias con dependencias F
Sea R1 el subesquema de R

F1 = F
X = R - R1 // Conjunto de atributos a eliminar
```



### Descomposición sin Pérdida de Información

Para dos esquemas $R_1$ y $R_2$ que provienen de descomponer $R$:

$$ (R_1 \cap R_2) \rightarrow (R_1 - R_2) \in F^+ $$
o bien
$$ (R_1 \cap R_2) \rightarrow (R_2 - R_1) \in F^+ $$

Esto asegura que la descomposición es **sin pérdida de información**.

**Para N esquemas:**  
Se utiliza una matriz especial llamada **tableau**. Si al finalizar el algoritmo, existe una fila donde todas las variables son distinguidas ($a_j$), entonces la descomposición es sin pérdida.



### Proyección de Dependencias Funcionales (Algoritmo de Gottlob)

**Precondición:** Las dependencias funcionales deben tener un solo atributo a la derecha.

**Algoritmo:**
1. Sea $F_1 = F$ y $X = R - R_1$ (atributos a eliminar).
2. Mientras $X \neq \emptyset$:
    - Tomar $A \in X$ y quitarlo de $X$.
    - Para cada dependencia $Y \rightarrow A$ en $F_1$:
        - Para cada dependencia $AZ \rightarrow B$ en $F_1$:
            - Generar $YZ \rightarrow B$ (si es no trivial).
    - Eliminar de $F_1$ todas las dependencias que incluyan $A$.
    - Agregar las nuevas dependencias generadas.

---
    // Iterar sobre dependencias en F1 cuyo lado derecho es A

## Recubrimiento Minimal de un Conjunto de Dependencias ($F_m$)

El **recubrimiento minimal** de $F$ es un conjunto equivalente de dependencias funcionales que cumple:
1. $F_m$ es equivalente a $F$ (tienen la misma clausura).
2. En cada dependencia funcional de $F_m$, el lado derecho es un solo atributo.
3. No hay atributos redundantes en el lado izquierdo de ninguna dependencia.
4. No hay dependencias funcionales redundantes en $F_m$.

**Pasos para obtener el recubrimiento minimal:**
1. Descomponer las dependencias para que el lado derecho tenga un solo atributo.
2. Eliminar atributos redundantes del lado izquierdo.
3. Eliminar dependencias redundantes.

---
        
        // Iterar sobre dependencias en F1 cuyo lado izquierdo contiene A
        for (cada dependencia del tipo AZ → B ∈ F1) {
            
    for (cada dependencia f ∈ F1) {

## Formas Normales

### Primera Forma Normal (1NF)

Un esquema está en 1NF si todos los atributos contienen valores atómicos (no multivaluados ni compuestos).

### Segunda Forma Normal (2NF)

Un esquema está en 2NF si:
- Está en 1NF.
- No existen atributos no primos que dependan parcialmente de una clave candidata (es decir, todo atributo no primo depende de toda la clave y no solo de una parte).

*Atributo primo*: pertenece a alguna clave candidata.

### Tercera Forma Normal (3NF)

Un esquema está en 3NF si:
- Para toda dependencia funcional $A \rightarrow B$, se cumple que $A$ es superclave o $B$ es atributo primo.

**Algoritmo para normalizar a 3NF:**
1. Hallar el recubrimiento minimal $F_m$.
2. Agrupar dependencias con el mismo lado izquierdo.
3. Para cada $X \rightarrow Y$ de $F_m$, crear el esquema $XY$.
4. Eliminar esquemas que sean subconjuntos de otros.
5. Si ningún esquema contiene una clave de $R$, agregar un esquema que la contenga.

### Forma Normal de Boyce-Codd (BCNF)

Un esquema está en BCNF si:
- Para toda dependencia funcional no trivial $A \rightarrow B$ en $F^+$, $A$ es superclave.


¿El hecho de que dos valores coincidan en todas las filas implica necesariamente una dependencia funcional?  
No. Podría ocurrir por casualidad en los datos actuales, pero una dependencia funcional es una restricción lógica sobre todos los posibles estados de la base, no solo sobre los datos presentes. Por eso, no se debe asumir una dependencia funcional solo porque se observa en los datos: debe ser garantizada por el diseño o las reglas del negocio.
    
    // Agregar las dependencias generadas (RES) a F1
    F1 = F1 ∪ RES
}
```

## TIPS

si quiero ver si se cumple $X \rightarrow Y$ basta con ver que $Y \in (X)^+$

## Recubrimiento minimal de F

$F_m$ es recubrimiento minimal de $F$ si:

1. $F_m$ es equivalente a $F$
2. A la derecha de toda dependencia funcional $df \in F_m$ hay un atributo simple
3. Ninguna $df \in F_m$ tiene atributos redundantes a izquierda
4. $F_m$ no tiene df redundantes

## Forma normal

### 1NF

### 2NF

si tengo un chabon no primo, que depende solo de una parte de la clave,
entonces separo bro porque para que sea 2NF un chabon no primo tiene que depender de toda la clave. Osea no tiene que tener una *dependencia parcial*

*(que sea primo significa que no esta en ninguna clave)

### 3NF

Un esquema de relacion R se encuentra en 3NF si se cumple que 

$\forall A \rightarrow B$ A es superclave o B es primo

para normalizar uin esquema que viola 3NF hay que 

1. Hallar $F_m$
2. Juntar dependencias que coinciden en el lado izq
3. Para cada $X \rightarrow Y$ de $F_m$ (luego del paso 2) crear el esquema XY
4. Eliminar todo esquema subconjunto de otro
5. Si ninguno de los esquemas creados contiene una clave de R, agregar un esquema conteniendola

### BCNF

Un esquema de relacion R e encuentra en BCNF si se cumple que

$\forall A \rightarrow B$ no trivial $ \in F^+$: A es superclave






## Preguntas

lo de que coincidan en todas hace que este la dependencia, eso no estaria mal asumirlo ya que podria venir una entrada a la tabla nueva con un insert que no cumpla esto? Es decir, no puede ser que coincidan de casualidad y no porque haya una dependencia funcional?

