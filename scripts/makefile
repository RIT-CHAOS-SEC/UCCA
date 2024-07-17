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

co-located_isr :
	sh build/run "co-located_isr" true
	
two_isrs  :
	sh build/run "two_isrs" true
cr_write_fst :
	sh build/run "violations_cr_integrity/cr_write_fst" true
		
cr_write_mid :
	sh build/run "violations_cr_integrity/cr_write_mid" true
	
cr_write_last :
	sh build/run "violations_cr_integrity/cr_write_last" true

isr_return_invalid :
	sh build/run "violations_return_integrity/isr_return_invalid" true
		
malicious_return_simple :
	sh build/run "violations_return_integrity/malicious_return_simple" true
	
malicious_return_complex :
	sh build/run "violations_return_integrity/malicious_return_complex" true
	
malicious_stack_write_simple :
	sh build/run "violations_stack_integrity/malicious_stack_write_simple" true
	
malicious_stack_write_complex :
	sh build/run "violations_stack_integrity/malicious_stack_write_complex" true

malicious_stack_pointer :
	sh build/run "violations_stack_integrity/malicious_stack_pointer" true
	
write_to_pointer :
	sh build/run "violations_stack_integrity/write_to_pointer" true
	
isr_write_invalid :
	sh build/run "violations_stack_integrity/isr_write_invalid" true
	
isr_write_valid :
	sh build/run "violations_stack_integrity/isr_write_valid" true

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
