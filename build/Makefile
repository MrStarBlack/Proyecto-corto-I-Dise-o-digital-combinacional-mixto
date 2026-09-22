# ==========================================
# CONFIGURACIÓN GENERAL
# ==========================================

PROYECT := hamming
BOARD   := tangnano9k
DEVICE  := GW1NR-LV9QN88PC6/I5
FAMILY  := GW1N-9C

TOP_DESIGN := moduloTop
CONSTRAINTS := ../constr/Tangnano9k.cst


# ==========================================
# ==========================================
#             ZONA HAMMING
# ==========================================
# ==========================================

# Módulo principal de la zona Hamming
HAMMING_SOURCE := ../design/moduloTop.sv

# Generación / lectura de palabra Hamming
HAMMING_WORD_SOURCE := ../design/Lectura_Palabra.sv

# Generacion de la inyección del errror
HAMMING_ERROR_SOURCE := ../design/Inyeccion_Error_Hamming.sv

# Testbench de lectura de palabra
HAMMING_WORD_TESTBENCH := ../sim/tb_Lectura_Palabra.sv
HAMMING_WORD_TOP_TB := Lectura_Palabra_tb

# Testbench de inyección de error
HAMMING_ERROR_TESTBENCH := ../sim/tb_Inyeccion_Error_Hamming.sv
HAMMING_ERROR_TOP_TB := tb_Inyeccion_Error_Hamming
HAMMING_ERROR_VCD_FILE := Inyeccion_Error_Hamming.vcd


# ==========================================
# ==========================================
#          PRUEBAS ZONA TRANSMISOR
# ==========================================
# ==========================================

test_lectura: ${HAMMING_WORD_SOURCE} ${HAMMING_WORD_TESTBENCH}

	@iverilog \
		-o lectura_palabra_test.o \
		-s ${HAMMING_WORD_TOP_TB} \
		-g2005-sv \
		${HAMMING_WORD_TESTBENCH} ${HAMMING_WORD_SOURCE}
	@vvp lectura_palabra_test.o
	
# Testbench de inyección de error Hamming
test_inyeccion: ${HAMMING_ERROR_SOURCE} ${HAMMING_ERROR_TESTBENCH}

	@echo "=========================================="
	@echo " TESTBENCH INYECCION DE ERROR HAMMING"
	@echo "=========================================="
	@iverilog \
		-o hamming_error_injection_test.o \
		-s ${HAMMING_ERROR_TOP_TB} \
		-g2005-sv \
		${HAMMING_ERROR_TESTBENCH} ${HAMMING_ERROR_SOURCE}
	@vvp hamming_error_injection_test.o

# Fuentes utilizadas para la FPGA
SOURCES := \
	${HAMMING_SOURCE} \
	${HAMMING_WORD_SOURCE} \
	${HAMMING_ERROR_SOURCE}



# ==========================================
# ==========================================
#             ZONA RECEPTOR
# ==========================================
# ==========================================

# Decodificador de paridad
PARITY_SOURCE := ../design/parity_decoder.sv
PARITY_TESTBENCH := ../sim/tb_parity_decoder.sv
PARITY_TOP_TB := tb_parity_decoder
PARITY_VCD_FILE := parity_decoder.vcd

# Síndrome Hamming
SYNDROME_SOURCE := ../design/syndrome_decoder.sv
SYNDROME_TESTBENCH := ../sim/tb_syndrome_decoder.sv
SYNDROME_TOP_TB := tb_syndrome_decoder
SYNDROME_VCD_FILE := syndrome_decoder.vcd

# Corrección de errores
CORRECTION_SOURCE := ../design/error_correction.sv
CORRECTION_TESTBENCH := ../sim/tb_error_correction.sv
CORRECTION_TOP_TB := tb_error_correction
CORRECTION_VCD_FILE := error_correction.vcd

# Display del receptor
DISPLAY_SOURCE := ../design/display_decoder.sv
DISPLAY_TESTBENCH := ../sim/tb_display_decoder.sv
DISPLAY_TOP_TB := tb_display_decoder
DISPLAY_VCD_FILE := display_decoder.vcd


# ==========================================
# COMPILACIÓN FPGA
# ==========================================

all: synth pnr bitstream load


# ==========================================
# SÍNTESIS
# ==========================================

synth: ${SOURCES}
	@echo "=========================================="
	@echo "     SINTESIS - PROYECTO HAMMING"
	@echo "=========================================="
	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN}; stat; write_json ${PROYECT}.json"
	@echo "SINTESIS COMPLETADA"

# ==========================================
# PLACE AND ROUTE
# ==========================================

pnr: ${PROYECT}.json
	@echo "=========================================="
	@echo "     PLACE AND ROUTE"
	@echo "=========================================="
	nextpnr-gowin --json ${PROYECT}.json \
		--write ${PROYECT}_pnr.json \
		--freq 27 \
		--device ${DEVICE} \
		--family ${FAMILY} \
		--cst ${CONSTRAINTS}
	@echo "PNR COMPLETADO"


# ==========================================
# BITSTREAM
# ==========================================

bitstream: ${PROYECT}_pnr.json
	@echo "=========================================="
	@echo "     GENERANDO BITSTREAM"
	@echo "=========================================="
	@gowin_pack \
		-d ${FAMILY} \
		-o ${PROYECT}_${BOARD}.fs \
		${PROYECT}_pnr.json
	@echo "BITSTREAM COMPLETADO"


# ==========================================
# ==========================================
#          PRUEBAS ZONA RECEPTOR
# ==========================================
# ==========================================

test_parity: ${PARITY_SOURCE} ${PARITY_TESTBENCH}
	@echo "Ejecutando testbench de paridad..."
	@iverilog \
		-o parity_decoder_test.o \
		-s ${PARITY_TOP_TB} \
		-g2005-sv \
		${PARITY_TESTBENCH} ${PARITY_SOURCE}
	@vvp parity_decoder_test.o


test_syndrome: ${SYNDROME_SOURCE} ${SYNDROME_TESTBENCH}
	@echo "Ejecutando testbench de sindrome..."
	@iverilog \
		-o syndrome_decoder_test.o \
		-s ${SYNDROME_TOP_TB} \
		-g2005-sv \
		${SYNDROME_TESTBENCH} ${SYNDROME_SOURCE}
	@vvp syndrome_decoder_test.o


test_correction: ${CORRECTION_SOURCE} ${CORRECTION_TESTBENCH}
	@echo "Ejecutando testbench de correccion..."
	@iverilog \
		-o error_correction_test.o \
		-s ${CORRECTION_TOP_TB} \
		-g2005-sv \
		${CORRECTION_TESTBENCH} ${CORRECTION_SOURCE}
	@vvp error_correction_test.o


test_display: ${DISPLAY_SOURCE} ${DISPLAY_TESTBENCH}
	@echo "Ejecutando testbench del display..."
	@iverilog \
		-o display_decoder_test.o \
		-s ${DISPLAY_TOP_TB} \
		-g2005-sv \
		${DISPLAY_TESTBENCH} ${DISPLAY_SOURCE}
	@vvp display_decoder_test.o


# ==========================================
# CARGAR FPGA
# ==========================================

load: ${PROYECT}_${BOARD}.fs
	@echo "Cargando FPGA..."
	openFPGALoader -b ${BOARD} ${PROYECT}_${BOARD}.fs
	@echo "FPGA CARGADA"


# ==========================================
# LIMPIAR
# ==========================================

clean:
	cmd /C "del /Q hamming.json 2>nul"
	cmd /C "del /Q hamming_pnr.json 2>nul"
	cmd /C "del /Q hamming_tangnano9k.fs 2>nul"
	cmd /C "del /Q parity_decoder_test.o 2>nul"
	cmd /C "del /Q syndrome_decoder_test.o 2>nul"
	cmd /C "del /Q error_correction_test.o 2>nul"
	cmd /C "del /Q display_decoder_test.o 2>nul"
	cmd /C "del /Q *.vcd 2>nul"
	cmd /C "del /Q synthesis_tangnano9k.log 2>nul"
	cmd /C "del /Q lectura_palabra_test.o 2>nul"
	cmd /C "del /Q display_decoder_test.o 2>nul"


# ==========================================
# PHONY
# ==========================================

.PHONY: all synth pnr bitstream load clean \
	test_lectura test_inyeccion \
	test_parity test_syndrome test_correction test_display

.INTERMEDIATE: \
	${PROYECT}_pnr.json \
	${PROYECT}.json \
	${PROYECT}_test.o \
	lectura_palabra_test.o \
	hamming_error_injection_test.o \
	parity_decoder_test.o \
	syndrome_decoder_test.o \
	error_correction_test.o \
	display_decoder_test.o