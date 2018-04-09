`default_nettype none
module demo(
  input      clk,
  output reg LED0,
  output reg LED1,
  output reg LED2,
  output reg LED3,
  output reg LED4,
  output reg LED5,
  output reg LED6,
  output reg LED7,
  input      PMOD1, // input A
  input      PMOD2, // input B
  input      PMOD3, // run/stop
  input      PMOD4  // reset
);


  // Manage 12MHz clock
  reg [15:0]  cnt1;
  reg [6:0]   cnt2;
  reg [7:0]   dec_cntr;
  reg         half_sec_pulse;

  // Alias inputs
  wire   inA;
  wire   inB;
  wire   runstop;
  wire   reset;

  assign inA=PMOD1;
  assign inB=PMOD2;
  assign runstop=PMOD3;
  assign reset=PMOD4;



  // The 12MHz clock is too fast
  // The first counter will / 2^16 (about 5.46ms)
  // Then the second counter goes to 91 which is 0.497s
  // close enough to 1/2 second for our purpose
  always@(posedge clk)
  begin
    if (reset==1'b1)
    begin
      cnt1 <= 0;
      cnt2 <= 0;
      half_sec_pulse <= 0;
      dec_cntr <= 0;
    end
    else if (runstop==1'b0)  // don't do anything unless enabled
    begin
      cnt1 <= cnt1 + 1;
      if (cnt1 == 0)
      begin
        if (cnt2 == 91)
        begin
          cnt2 <= 0;
          half_sec_pulse <= 1;
        end
        else
          cnt2 <= cnt2 + 1;
      end
      else
        half_sec_pulse <= 0;

      if (half_sec_pulse == 1)
        dec_cntr <= dec_cntr + 1; // count half seconds
      // note: dec_cntr>>1 is a seconds timer, but dec_cntr is only 2 bits so 0-3...
    end
  end







  // // Carry from addition
  // wire  carry;
  // wire  in_or;
  //
  // // remember carry result
  // reg   carrylatch;
  //
  //
  // always
  // begin
  //   in_or <= inA ^ inB;   // 1/2 adder with carry output
  //   carry <= inA & inB;  // we use carry in more than one place
  // end
  //
  // assign LED2 = in_or;
  // assign LED3 = carry;
  // assign LED4 = carrylatch;
  //
  // // latch carry result
  // always @(posedge clk)
  // begin
  //   if (reset==1'b1)
  //     carrylatch<=1'b0;
  //   else if (carry)
  //     carrylatch<=1'b1;
  // end
  //
  //
  //
  //
  // // Make the lights blink
  // assign LED0 = (dec_cntr == 2) ;
  // assign LED1 = dec_cntr[0];


  assign LED0 = dec_cntr[0];
  assign LED1 = dec_cntr[1];
  assign LED2 = dec_cntr[2];
  assign LED3 = dec_cntr[3];
  assign LED4 = dec_cntr[4];
  assign LED5 = dec_cntr[5];
  assign LED6 = dec_cntr[6];
  assign LED7 = dec_cntr[7];
endmodule
