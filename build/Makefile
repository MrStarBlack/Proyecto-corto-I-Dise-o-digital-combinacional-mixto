# ==========================================
# CONFIGURACION GENERAL
# ==========================================

BOARD   := tangnano9k
DEVICE  := GW1NR-LV9QN88PC6/I5
FAMILY  := GW1N-9C

# ==========================================
# SELECCION DEL SISTEMA
#
# TX = Transmisor
# RX = Receptor
#
# Por defecto:
# TX
#
# Ejemplos:
#
# make all
# make all MODE=TX
# make all MODE=RX
# ==========================================

MODE ?= RX


# ==========================================
# ==========================================
#             ZONA TRANSMISOR
# ==========================================
# ==========================================

# Modulo principal del transmisor
HAMMING_SOURCE := ../design/moduloTop.sv

# Generacion / lectura de palabra Hamming
HAMMING_WORD_SOURCE := ../design/Lectura_Palabra.sv

# Inyeccion de error
HAMMING_ERROR_SOURCE := ../design/Inyeccion_Error_Hamming.sv


# Testbench lectura de palabra
HAMMING_WORD_TESTBENCH := ../sim/tb_Lectura_Palabra.sv
HAMMING_WORD_TOP_TB := Lectura_Palabra_tb

# Testbench inyeccion de error
HAMMING_ERROR_TESTBENCH := ../sim/tb_Inyeccion_Error_Hamming.sv
HAMMING_ERROR_TOP_TB := tb_Inyeccion_Error_Hamming


# ==========================================
# ==========================================
#             ZONA RECEPTOR
# ==========================================
# ==========================================

# Top receptor
RECEIVER_TOP_SOURCE := ../design/moduloTopRecep.sv

# Verificador de paridad
PARITY_SOURCE := ../design/Verificador_Paridad.sv
PARITY_TESTBENCH := ../sim/tb_Verificador_Paridad.sv
PARITY_TOP_TB := tb_Verificador_Paridad

# Determinacion del sindrome
SYNDROME_SOURCE := ../design/Determinacion_Sindrome.sv
SYNDROME_TESTBENCH := ../sim/tb_Determinacion_Sindrome.sv
SYNDROME_TOP_TB := TB_Determinacion_Sindrome

# Correccion de errores
CORRECTION_SOURCE := ../design/Correccion_error.sv
CORRECTION_TESTBENCH := ../sim/tb_Correccion_error.sv
CORRECTION_TOP_TB := tb_Correccion_error

# Display
DISPLAY_SOURCE := ../design/Display_Receptor.sv
DISPLAY_TESTBENCH := ../sim/tb_Display_Receptor.sv
DISPLAY_TOP_TB := tb_Display_Receptor


# ==========================================
# ==========================================
#          CONFIGURACION SEGUN MODO
# ==========================================
# ==========================================

ifeq ($(MODE),TX)

TOP_DESIGN := moduloTop
CONSTRAINTS := ../constr/Tangnano9k.cst


SOURCES := \
	${HAMMING_SOURCE} \
	${HAMMING_WORD_SOURCE} \
	${HAMMING_ERROR_SOURCE}

else ifeq ($(MODE),RX)

TOP_DESIGN := moduloTopRecep
CONSTRAINTS := ../constr/Tangnano9kRecep.cst


SOURCES := \
	${RECEIVER_TOP_SOURCE} \
	${PARITY_SOURCE} \
	${SYNDROME_SOURCE} \
	${CORRECTION_SOURCE} \
	${DISPLAY_SOURCE}

else

$(error MODE debe ser TX o RX)

endif


# ==========================================
# MOSTRAR CONFIGURACION
# ==========================================

info:
	@echo "=========================================="
	@echo "       CONFIGURACION DEL PROYECTO"
	@echo "=========================================="
	@echo "MODO        : ${MODE}"
	@echo "TOP         : ${TOP_DESIGN}"
	@echo "CONSTRAINTS : ${CONSTRAINTS}"
	@echo "=========================================="


# ==========================================
# ==========================================
#             COMPILACION FPGA
# ==========================================
# ==========================================

all: synth pnr bitstream load


# ==========================================
# SINTESIS
# ==========================================

synth: ${SOURCES}

	@echo "=========================================="
	@echo "             SINTESIS FPGA"
	@echo "=========================================="

	@echo "MODO        : ${MODE}"
	@echo "TOP         : ${TOP_DESIGN}"
	@echo "CONSTRAINTS : ${CONSTRAINTS}"

	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN}; stat; write_json ${PROYECT}.json"

	@echo "=========================================="
	@echo "SINTESIS COMPLETADA"
	@echo "=========================================="


# ==========================================
# PLACE AND ROUTE
# ==========================================

pnr: ${PROYECT}.json

	@echo "=========================================="
	@echo "             PNR"
	@echo "=========================================="

	@nextpnr-gowin \
		--json ${PROYECT}.json \
		--write ${PROYECT}_pnr.json \
		--freq 27 \
		--device ${DEVICE} \
		--family ${FAMILY} \
		--cst ${CONSTRAINTS}

	@echo "=========================================="
	@echo "PNR COMPLETADO"
	@echo "=========================================="


# ==========================================
# BITSTREAM
# ==========================================

bitstream: ${PROYECT}_pnr.json

	@echo "=========================================="
	@echo "             BITSTREAM"
	@echo "=========================================="

	@gowin_pack \
		-d ${FAMILY} \
		-o ${PROYECT}_${BOARD}.fs \
		${PROYECT}_pnr.json

	@echo "=========================================="
	@echo "BITSTREAM COMPLETADO"
	@echo "=========================================="


# ==========================================
# ==========================================
#          PRUEBAS ZONA TRANSMISOR
# ==========================================
# ==========================================

test_lectura: ${HAMMING_WORD_SOURCE} ${HAMMING_WORD_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH LECTURA DE PALABRA"
	@echo "=========================================="

	@iverilog \
		-o lectura_palabra_test.o \
		-s ${HAMMING_WORD_TOP_TB} \
		-g2005-sv \
		${HAMMING_WORD_TESTBENCH} \
		${HAMMING_WORD_SOURCE}

	@vvp lectura_palabra_test.o


test_inyeccion: ${HAMMING_ERROR_SOURCE} ${HAMMING_ERROR_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH INYECCION DE ERROR HAMMING"
	@echo "=========================================="

	@iverilog \
		-o hamming_error_injection_test.o \
		-s ${HAMMING_ERROR_TOP_TB} \
		-g2005-sv \
		${HAMMING_ERROR_TESTBENCH} \
		${HAMMING_ERROR_SOURCE}

	@vvp hamming_error_injection_test.o


# ==========================================
# ==========================================
#          PRUEBAS ZONA RECEPTOR
# ==========================================
# ==========================================

test_parity: ${PARITY_SOURCE} ${PARITY_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH VERIFICADOR DE PARIDAD"
	@echo "=========================================="

	@iverilog \
		-o Verificador_Paridad_test.o \
		-s ${PARITY_TOP_TB} \
		-g2005-sv \
		${PARITY_TESTBENCH} \
		${PARITY_SOURCE}

	@vvp Verificador_Paridad_test.o


test_syndrome: ${SYNDROME_SOURCE} ${SYNDROME_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH DETERMINACION DEL SINDROME"
	@echo "=========================================="

	@iverilog \
		-o Determinacion_Sindrome_test.o \
		-s ${SYNDROME_TOP_TB} \
		-g2005-sv \
		${SYNDROME_TESTBENCH} \
		${SYNDROME_SOURCE}

	@vvp Determinacion_Sindrome_test.o


test_correction: ${CORRECTION_SOURCE} ${CORRECTION_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH CORRECCION DE ERROR"
	@echo "=========================================="

	@iverilog \
		-o Correccion_error_test.o \
		-s ${CORRECTION_TOP_TB} \
		-g2005-sv \
		${CORRECTION_TESTBENCH} \
		${CORRECTION_SOURCE}

	@vvp Correccion_error_test.o


test_display: ${DISPLAY_SOURCE} ${DISPLAY_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH DISPLAY RECEPTOR"
	@echo "=========================================="

	@iverilog \
		-o Display_Receptor_test.o \
		-s ${DISPLAY_TOP_TB} \
		-g2005-sv \
		${DISPLAY_TESTBENCH} \
		${DISPLAY_SOURCE}

	@vvp Display_Receptor_test.o


# ==========================================
# PRUEBA COMPLETA DEL RECEPTOR
# ==========================================

test_receiver: \
	${RECEIVER_TOP_SOURCE} \
	${PARITY_SOURCE} \
	${SYNDROME_SOURCE} \
	${CORRECTION_SOURCE} \
	${DISPLAY_SOURCE}

	@echo "=========================================="
	@echo "     COMPILACION DEL RECEPTOR COMPLETO"
	@echo "=========================================="

	@iverilog \
		-g2005-sv \
		-s moduloTopRecep \
		-o receptor_test.o \
		${RECEIVER_TOP_SOURCE} \
		${PARITY_SOURCE} \
		${SYNDROME_SOURCE} \
		${CORRECTION_SOURCE} \
		${DISPLAY_SOURCE}

	@echo "=========================================="
	@echo "RECEPTOR COMPILADO CORRECTAMENTE"
	@echo "=========================================="


# ==========================================
# CARGAR FPGA
# ==========================================

load: ${PROYECT}_${BOARD}.fs

	@echo "=========================================="
	@echo "          CARGANDO FPGA"
	@echo "=========================================="

	@openFPGALoader \
		-b ${BOARD} \
		${PROYECT}_${BOARD}.fs

	@echo "=========================================="
	@echo "FPGA CARGADA"
	@echo "=========================================="


# ==========================================
# LIMPIAR
# ==========================================

# ==========================================
# LIMPIAR
# ==========================================

clean:
	cmd /C "del /Q hamming_tx.json 2>nul"
	cmd /C "del /Q hamming_tx_pnr.json 2>nul"
	cmd /C "del /Q hamming_tx_tangnano9k.fs 2>nul"

	cmd /C "del /Q hamming_rx.json 2>nul"
	cmd /C "del /Q hamming_rx_pnr.json 2>nul"
	cmd /C "del /Q hamming_rx_tangnano9k.fs 2>nul"

	cmd /C "del /Q lectura_palabra_test.o 2>nul"
	cmd /C "del /Q hamming_error_injection_test.o 2>nul"

	cmd /C "del /Q Verificador_Paridad_test.o 2>nul"
	cmd /C "del /Q Determinacion_Sindrome_test.o 2>nul"
	cmd /C "del /Q Correccion_error_test.o 2>nul"
	cmd /C "del /Q Display_Receptor_test.o 2>nul"
	cmd /C "del /Q receptor_test.o 2>nul"

	cmd /C "del /Q *.vcd 2>nul"
	cmd /C "del /Q synthesis_tangnano9k.log 2>nul"


# ==========================================
# PHONY
# ==========================================

.PHONY: \
	all \
	info \
	synth \
	pnr \
	bitstream \
	load \
	clean \
	test_lectura \
	test_inyeccion \
	test_parity \
	test_syndrome \
	test_correction \
	test_display \
	test_receiver


# ==========================================
# INTERMEDIOS
# ==========================================
.INTERMEDIATE: \
	hamming_tx.json \
	hamming_tx_pnr.json \
	hamming_rx.json \
	hamming_rx_pnr.json \
	lectura_palabra_test.o \
	hamming_error_injection_test.o \
	Verificador_Paridad_test.o \
	Determinacion_Sindrome_test.o \
	Correccion_error_test.o \
	Display_Receptor_test.o \
	receptor_test.o