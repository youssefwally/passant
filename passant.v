module showdigit (
	input i_Clk,
	input [3:0] bcd,
	output [6:0] HEX0
);

reg [6:0] r_Hex_Encoding = 7'h00;

 always @(posedge i_Clk)
    begin
      case (bcd)
        4'b0000 : r_Hex_Encoding <= 7'h7E;
        4'b0001 : r_Hex_Encoding <= 7'h30;
        4'b0010 : r_Hex_Encoding <= 7'h6D;
        4'b0011 : r_Hex_Encoding <= 7'h79;
        4'b0100 : r_Hex_Encoding <= 7'h33;          
        4'b0101 : r_Hex_Encoding <= 7'h5B;
        4'b0110 : r_Hex_Encoding <= 7'h5F;
        4'b0111 : r_Hex_Encoding <= 7'h70;
        4'b1000 : r_Hex_Encoding <= 7'h7F;
        4'b1001 : r_Hex_Encoding <= 7'h7B;
        4'b1010 : r_Hex_Encoding <= 7'h77;
        4'b1011 : r_Hex_Encoding <= 7'h1F;
        4'b1100 : r_Hex_Encoding <= 7'h4E;
        4'b1101 : r_Hex_Encoding <= 7'h3D;
        4'b1110 : r_Hex_Encoding <= 7'h4F;
        4'b1111 : r_Hex_Encoding <= 7'h47;
      endcase
 end
  
 assign HEX0[0] = ~r_Hex_Encoding[6];
 assign HEX0[1] = ~r_Hex_Encoding[5];
 assign HEX0[2] = ~r_Hex_Encoding[4];
 assign HEX0[3] = ~r_Hex_Encoding[3];
 assign HEX0[4] = ~r_Hex_Encoding[2];
 assign HEX0[5] = ~r_Hex_Encoding[1];
 assign HEX0[6] = ~r_Hex_Encoding[0];
endmodule 


/*................*/
module shownumber(
	input i_Clk, 
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	input [32:0] num
);

wire [3:0] d0 = num % 10;
wire [3:0] d1 = (num / 10) % 10 ;
wire [3:0] d2 = (num / 100) % 10;
wire [3:0] d3 = (num / 1000) % 10;
wire [3:0] d4 = (num / 10000) % 10;
wire [3:0] d5 = (num / 100000) % 10;

 showdigit cd0 (
	i_Clk,
	d0,
	HEX0
 );
 
 showdigit cd1 (
	i_Clk,
	d1,
	HEX1
 );
 
 showdigit cd2 (
	i_Clk,
	d2,
	HEX2
 );
 
 showdigit cd3 (
	i_Clk,
	d3,
	HEX3
 );
 
 showdigit cd4 (
	i_Clk,
	d4,
	HEX4
 );
 
 showdigit cd5 (
	i_Clk,
	d5,
	HEX5
 );
   
endmodule 

/*.....................*/
module sonic(
   input clock,
	output trig,
	input echo,
	output reg [32:0] distance
);

reg [32:0] us_counter = 0;
reg _trig = 1'b0;

reg [9:0] one_us_cnt = 0;
wire one_us = (one_us_cnt == 0);

reg [9:0] ten_us_cnt = 0;
wire ten_us = (ten_us_cnt == 0);

reg [21:0] forty_ms_cnt = 0;
wire forty_ms = (forty_ms_cnt == 0);

assign trig = _trig;

always @(posedge clock) begin
	one_us_cnt <= (one_us ? 50 : one_us_cnt) - 1;
	ten_us_cnt <= (ten_us ? 500 : ten_us_cnt) - 1;
	forty_ms_cnt <= (forty_ms ? 2000000 : forty_ms_cnt) - 1;
	
	if (ten_us && _trig)
		_trig <= 1'b0;
	
	if (one_us) begin	
		if (echo)
			us_counter <= us_counter + 1;
		else if (us_counter) begin
			distance <= us_counter / 58;
			us_counter <= 0;
		end
	end
	
   if (forty_ms)begin
		_trig <= 1'b1;
		end
		end

endmodule 

/*.......................*/
module clk11 (clko,clki);
input clki;
output clko;
reg [24:0] counter;
reg clko = 1'b0;
initial begin
counter <= 0;
clko <= 0;
end
always @(posedge clki)begin
if (counter==0)begin
counter<=25'd2499999;
clko <= ~clko;
end
else begin
counter <= counter-25'd1;
end
end
endmodule
/*****************************/

module passant(
   input clk50,
   output trig,
	output trig2,	
   input echo,
	input echo2,
   input clk10, 
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX02,
	output [6:0] HEX12,
	output [6:0] HEX22,
	output [6:0] HEX32,
	output [6:0] HEX42,
	output [6:0] HEX52,
	output  reg o ,
	output reg o2 
	);
	wire clko ;
  wire [32:0] distance;
  wire [32:0] distance2;
  reg [20:0] c=0;
  reg [20:0] t = 24;
  reg flag=1;
  reg flag2=1;
  clk11 ccc (clko , clk50);
  
  sonic sc (
    clk50,
	 trig,
	 echo,
	 distance
  );
  sonic sc2 (
    clk50,
	 trig2,
	 echo2,
	 distance2
  );
   
  shownumber sn (
    clk10,
	 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	 c
  );
  
  shownumber sn2 (
    clk10,
	 HEX02, HEX12, HEX22, HEX32, HEX42, HEX52,
	 t
  );
  
  always @(posedge clko) begin
  //o<=1;
 // o2<=0;
  case(c)
   0 : t<=24;
	10: t<=23;
	20 : t<=22;
	30 : t<=21;
	40 : t<=20;
	50 : t<=19;
	60 : t<=18;
   70: t<=17;
	80 : t<=16;
	90 : t<=15;
	100 : t<=14;
  endcase
 
  if(c<100)begin
  if(distance<80 & flag==1) begin
	c<=c+1;
	flag=0;
  end
  if(distance>=80)begin
  flag=1;
  end
  if(c>99)begin
  o<=0;
  o2<=1;
  end
  end 
  if(c<100)begin
  o<=1;
  o2<=0;
  end
  /****************/
  
  if(c>0)begin
  if(distance2<80 & flag2==1) begin
	c<=c-1;
	flag2=0;
  end
  if(distance2>=80)begin
  flag2=1;
  end
  if(c>99)begin
  o<=0;
  o2<=1;
  end
  end 
  if(c<100)begin
  o<=1;
  o2<=0;
  end
  
  
  /***************/
  end
  
  
endmodule 
