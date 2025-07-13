#!/bin/bash

cordura=5
declare -A inventario

function typewrite() {
    for ((i=0; i<${#1}; i++)); do
        echo -n "${1:$i:1}"
        sleep 0.02
    done
    echo
}

function glitch_face() {
cat << "EOF"

+++++++++++++++++++++++++++*###*+++++++++++++++++++++++++++
++++++++++++++++++++*%%%@@@@@%%@@@%#+++++++++++++++++++++++
++++++++++++++++++%%@@@@@@@@@@@@@@%%%@*++++++++++++++++++++
+++++++++++++++++@@@@@@@@@@@@@@@@@%%%@%%+++++++++++++++++++
+++++++++++++++#@@@@@@@@@@@@@@@%@@@%%%%%%**++++++++++++++++
++++++++++++++#@@@@@@@@@@@@@@@@@%@@@%%%%%%++*++++++++++++++
++++++++++++++%@@@@@%%%%%%@@@@%%%%%%%%%%%%%#**+++++++++++++
++++++++++++++%@@@@%##%%%%%%@%@%%%%%@%%%%%%%#*+++++++++++++
+++++++++++++*%@@@%%###%%%%%@@@%%%%%%@%%%@%%%#+++++++++++++
+++++++++++++*%%@@%#######%%%%%%%%%%%@%%#%@%%#+++++++++++++
+++++++++++++#%@@%%%%%%############%%%%%%%%%%#*++++++++++++
+++++++++++++#%@@%########***#%@@%#*##%%%%%%%%%*+++++++++++
+++++++++++++#%@%#%%%@%%##***####******#@%%#%##*+++++++++++
+++++++++++++*%@%##########**********+**%%##%#**+++++++++++
+++++++++++++*#@###########*********+++*%%##%#+++++++++++++
+++++++++++++++%@##########*++###***+*++%%###*+++++++++++++
+++++++++++++++*%###########****#*****++%%%%#*+++++++++++++
+++++++++++++++#**##########**********+*%####*+++++++++++++
+++++++++++++++#++#####%%%%%##********+#####**+++++++++++++
+++++++++++++++***+*#########**++*******+##*#++++++++++++++
++++++++++++++++#+++*#######***+++*****+++***++++++++++++++
+++++++++++++++++#++++*#####****+******+++*++++++++++++++++
+++++++++++++++++++#+++#########******++*#+++++++++++++++++
+++++++++++++++++++++**########*********#*+++++++++++++++++
+++++++++++++++++++++*#########*******+**+*++++++++++++++++
+++++++++++++++++*####%########********+**#*+**++++++++++++
+++++++++++**###################********#*##++*****++++++++
+++++*##########################********##***++*********+++
+++*########################*****##****#****#**************
++*##################**####****#####***********+***********
++*************************************#***+***+++*********
++++++++++++************+***#**+*****+*+#+*+**+++++++++++++

EOF
}

function maybe_glitch() {
    if (( RANDOM % 100 < 20 )); then
        glitch_face
        sleep 1
        typewrite "Algo... parpadea dentro de ti."
        ((cordura--))
        check_cordura
    fi
}

function check_cordura() {
    if (( cordura <= 0 )); then
        final_cordura
    fi
}

function show_inventory() {
    typewrite "Inventario:"
    for item in "${!inventario[@]}"; do
        echo "- $item"
    done
    echo ""
}

function timed_input() {
    prompt="$1"
    timeout_sec="$2"
    default="$3"

    echo -n "$prompt"
    read -t "$timeout_sec" -p " (Tienes $timeout_sec segundos)> " input
    if [[ $? -ne 0 ]]; then
        echo -e "\nNo respondiste a tiempo..."
        input="$default"
    fi
    echo "$input"
}

function prompt_restart() {
    echo ""
    typewrite "[1] Volver a intentarlo"
    typewrite "[2] Salir de este error"
    read -p "> " choice

    case $choice in
        1) cordura=5; inventario=(); start_game ;;
        2) typewrite "Pensaste que elegir era libertad."; exit ;;
        *) typewrite "El error también es decisión."; prompt_restart ;;
    esac
}

function start_game() {
    clear
    typewrite "..."
    sleep 1
    typewrite "Despiertas otra vez. O por primera vez. ¿Quién puede saberlo?"
    sleep 1
    main_room
}

function main_room() {
    clear
    typewrite "Estás en un cuarto blanco. Muy blanco. Como un error renderizado."
    maybe_glitch
    echo ""
    typewrite "[1] Leer el cuaderno"
    typewrite "[2] Mirarte al espejo"
    typewrite "[3] Salir por la puerta"
    input=$(timed_input "" 10 "3")

    case $input in
        1) notebook ;;
        2) mirror ;;
        3) hallway ;;
        *) typewrite "La indecisión es castigo."; ((cordura--)); check_cordura; main_room ;;
    esac
}

function notebook() {
    typewrite "El cuaderno tiene palabras tachadas. Algunas reaparecen solas."
    typewrite "\"No soy real. Solo registro el dolor de alguien más.\""
    maybe_glitch
    echo ""
    typewrite "[1] Romper el cuaderno"
    typewrite "[2] Guardarlo"
    read -p "> " choice

    case $choice in
        1) typewrite "Rasgas la última página. Se escucha un grito desde el suelo."; ((cordura--)); hallway ;;
        2) typewrite "Guardas el cuaderno. Sientes que alguien más lo quería contigo."; inventario["Cuaderno"]="guardado"; hallway ;;
        *) notebook ;;
    esac
}

function mirror() {
    typewrite "Tu reflejo no eres tú. Te copia, pero no al mismo ritmo."
    maybe_glitch
    glitch_face
    echo ""
    typewrite "[1] Romper el espejo"
    typewrite "[2] Alejarte"
    read -p "> " choice

    case $choice in
        1) typewrite "Se rompe. Tú no. Pero tu reflejo sigue viéndote."; ((cordura--)); true_end ;;
        2) typewrite "Te das vuelta, pero escuchas tu voz decir 'te odio' justo antes de irte."; hallway ;;
        *) mirror ;;
    esac
}

function hallway() {
    clear
    typewrite "El pasillo tiene retratos de ti en distintas muertes."
    maybe_glitch
    echo ""
    typewrite "[1] Seguir recto"
    typewrite "[2] Abrir puerta lateral"
    input=$(timed_input "" 8 "1")

    case $input in
        1) typewrite "Te repites. Te repites. Te repites."; ((cordura--)); bad_end ;;
        2) final_room ;;
        *) hallway ;;
    esac
}

function final_room() {
    typewrite "Alguien igual a ti está sentado. Sostiene un cuchillo y llora."
    typewrite "\"Este ciclo no es tuyo. Pero si estás aquí... es porque nadie más lo quiso romper.\""
    maybe_glitch
    if [[ ${inventario["Cuaderno"]} == "guardado" ]]; then
        typewrite "Él mira tu bolsillo. 'Tú lo traes... otra vez.'"
    fi
    echo ""
    typewrite "[1] Abrazarlo"
    typewrite "[2] Asfixiarlo"
    input=$(timed_input "" 7 "2")

    case $input in
        1) typewrite "Lo abrazas. Y por primera vez, no temes desaparecer."; true_end ;;
        2) typewrite "Muere. Y contigo algo más muere. Quizás tú."; sad_end ;;
        *) final_room ;;
    esac
}

function true_end() {
    echo ""
    typewrite "FINAL: Integración."
    show_inventory
    glitch_face
    prompt_restart
}

function sad_end() {
    echo ""
    typewrite "FINAL: El que sobró."
    show_inventory
    glitch_face
    prompt_restart
}

function bad_end() {
    echo ""
    typewrite "FINAL: Bucle consciente."
    typewrite "Recorrerás este pasillo hasta que no quede memoria."
    glitch_face
    prompt_restart
}

function final_cordura() {
    echo ""
    typewrite "FINAL: Fragmentación total."
    typewrite "Tu mente no resistió el bucle. Ahora otros hablarán con tu voz."
    glitch_face
    prompt_restart
}

start_game
