module alu (
    input  logic clk             ,
    input  logic rst             ,
    input  logic [3:0]  a        ,
    input  logic [3:0]  b        ,
    input  logic [1:0]  op       ,
    output logic [3:0] result
);

    always_ff @( posedge clk or posedge rst ) begin : blockName
        if (rst)
            result <= 0 ;
        else begin
            case(op)
                2'b00 : result <= a+b ;
                2'b01 : result <= a-b ;
                2'b10 : result <= a&b ;
                2'b11 : result <= a|b ; 
            endcase
        end
    end
endmodule