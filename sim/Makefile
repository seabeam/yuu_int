GUI ?=

all:
	make clean run

clean:
	ls | grep -v Makefile | grep -v top.sv | xargs rm -rf

run:
	vcs -sverilog -full64 -ntb_opts uvm-1.2 -q -debug_acc+all -kdb ../include/yuu_int_pkg.sv +incdir+../include+../src/sv top.sv -R $(GUI)
