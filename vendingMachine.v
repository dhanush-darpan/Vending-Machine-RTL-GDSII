module vendingMachine(output choco_out, output chng_out, input clk, input reset, input two_in, input one_in);

wire rst = 1'b1;
wire rstout;
reg sel;
reg [2:0] state, nextstate;

parameter idle = 3'b000;
parameter two_rs = 3'b001;
parameter one_rs = 3'b010;
parameter chocoout = 3'b011;
parameter chngout = 3'b100;

assign rstout = sel ? rst : reset;

//State Register
always@(posedge clk or posedge rstout) begin
if (rstout) state <= idle;
else state <= nextstate;
end

always@(negedge clk) begin
sel <= (state == chocoout | state == chngout);
end

//Next State Logic
always@(*) begin 
case (state)
idle : if(two_in & ~one_in)  nextstate = two_rs;
else if (one_in & ~two_in)  nextstate = one_rs;
else  nextstate = idle;

two_rs: if(two_in & ~one_in)  nextstate = chngout;
else if (one_in & ~two_in)  nextstate = chocoout;
else if (~two_in & ~one_in)  nextstate = two_rs;
else  nextstate = idle;

one_rs: if(two_in & ~one_in)  nextstate = chocoout;
else if (one_in & ~two_in)  nextstate = two_rs;
else if (~two_in & ~one_in)  nextstate = one_rs;
else  nextstate = idle;

chocoout: nextstate = idle;
chngout: nextstate = idle;
default: nextstate = idle;
endcase
end

//Output Logic
assign choco_out = (state == chocoout | state == chngout);
assign chng_out = (state == chngout);
endmodule
