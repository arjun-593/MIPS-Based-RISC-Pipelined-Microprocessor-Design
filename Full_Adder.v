`timescale 1ns/1ns

// Full Adder
module Full_Adder(output sum, cout, input a, b, cin);
  wire x,y,z;
 
  Half_Adder h1(.a(a),.b(b),.s(x),.c(y));
  Half_Adder h2(.a(x),.b(cin),.s(sum),.c(z));
  or o1(cout,y,z);
endmodule : Full_Adder

// Half Adder           
module Half_Adder(a,b,s,c); 
  input a,b;
  output s,c;
 
  xor x1(s,a,b); // Gate level design of half adder
  and a1(c,a,b);
endmodule :Half_Adder
