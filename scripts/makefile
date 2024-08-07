default :

install-clean :
	rm -rf ./verif-tools/verilog2smv-1.1.2 ./verif-tools/verilog2smv.sh	

install :
	cd verif-tools ; \
	tar -vxjf verilog2smv-1.1.2.tar.bz2 ; \
	cd verilog2smv-1.1.2 ; \
	sh build.sh ; \
	cp verilog2smv.sh ../

simple_app :
	sh build/run "simple_app" true
	python3 ./build/generate_simulation_hardware.py 3
	
generic_app :
	sh build/run "generic_app" true true
	python3 ./build/region_definitions.py "generic_app"
	sh build/run "generic_app" true false
	python3 ./build/generate_simulation_hardware.py -1
	rm "temp_uccs.txt"

co-located_isr :
	sh build/run "co-located_isr" true
	python3 ./build/generate_simulation_hardware.py 3
	
two_isrs  :
	sh build/run "two_isrs" true
	python3 ./build/generate_simulation_hardware.py 3
	
cr_write_fst :
	sh build/run "violations_cr_integrity/cr_write_fst" true
	python3 ./build/generate_simulation_hardware.py 3
		
cr_write_mid :
	sh build/run "violations_cr_integrity/cr_write_mid" true
	python3 ./build/generate_simulation_hardware.py 3
	
cr_write_last :
	sh build/run "violations_cr_integrity/cr_write_last" true
	python3 ./build/generate_simulation_hardware.py 3

isr_return_invalid :
	sh build/run "violations_return_integrity/isr_return_invalid" true
	python3 ./build/generate_simulation_hardware.py 3
		
malicious_return_simple :
	sh build/run "violations_return_integrity/malicious_return_simple" true
	python3 ./build/generate_simulation_hardware.py 3
	
malicious_return_complex :
	sh build/run "violations_return_integrity/malicious_return_complex" true
	python3 ./build/generate_simulation_hardware.py 3
	
malicious_stack_write_simple :
	sh build/run "violations_stack_integrity/malicious_stack_write_simple" true
	python3 ./build/generate_simulation_hardware.py 3
	
malicious_stack_write_complex :
	sh build/run "violations_stack_integrity/malicious_stack_write_complex" true
	python3 ./build/generate_simulation_hardware.py 3

malicious_stack_pointer :
	sh build/run "violations_stack_integrity/malicious_stack_pointer" true
	python3 ./build/generate_simulation_hardware.py 3
	
write_to_pointer :
	sh build/run "violations_stack_integrity/write_to_pointer" true
	python3 ./build/generate_simulation_hardware.py 3
	
isr_write_invalid :
	sh build/run "violations_stack_integrity/isr_write_invalid" true
	python3 ./build/generate_simulation_hardware.py 3
	
isr_write_valid :
	sh build/run "violations_stack_integrity/isr_write_valid" true
	python3 ./build/generate_simulation_hardware.py 3

verify_general :
	sh verif-tools/run "ucca"

verify_return_integrity:
	sh verif-tools/run "return"

verify_stack_integrity :
	sh verif-tools/run "stack"

verify_cr_integrity:
	sh verif-tools/run "cr"

	

clean :
	rm -rf simv *.mem pmem.inc stimulus.v tmp-build
