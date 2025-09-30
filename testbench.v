module testbench();
reg clk;
reg reset;
reg two_in, one_in;

wire choco_out, chng_out;

//Instantiate device to be tested
vendingMachine dut(choco_out, chng_out, clk, reset, two_in, one_in);

//generate clock to sequence test
always 
begin
clk <= 1; #50; clk <= 0; #50;
end

//initialise test
initial
begin
two_in <= 0; one_in <=0;
reset <= 1; #120; reset <= 0;
#80; two_in <= 1;
#300; two_in <= 0; one_in <= 1;
#300; one_in <= 0; two_in <= 1;
#50; two_in <= 0; one_in <= 1;
#50; one_in <= 0;
#200; one_in <= 1;
#50; one_in <= 0; two_in <= 1;
#50; two_in <= 0;
#200; one_in <= 1;
#100; one_in <= 0; two_in <= 1;
#200; one_in <= 0; two_in <= 0;
end

initial 
begin
#2000;
$finish();
end
endmodule
