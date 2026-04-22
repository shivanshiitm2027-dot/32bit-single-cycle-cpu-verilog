module control_unit (
    input  wire [5:0] opcode,
    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg        mem_to_reg,
    output reg        alu_src,
    output reg        reg_dst,
    output reg        branch,
    output reg [1:0]  alu_op
);

    always @(*) begin
        reg_write  = 1'b0;
        mem_read   = 1'b0;
        mem_write  = 1'b0;
        mem_to_reg = 1'b0;
        alu_src    = 1'b0;
        reg_dst    = 1'b0;
        branch     = 1'b0;
        alu_op     = 2'b00;

        case (opcode)
            6'b000000: begin // R-type
                reg_write = 1'b1;
                reg_dst   = 1'b1;
                alu_op    = 2'b10;
            end
            6'b100011: begin // LW
                reg_write  = 1'b1;
                mem_read   = 1'b1;
                mem_to_reg = 1'b1;
                alu_src    = 1'b1;
                alu_op     = 2'b00;
            end
            6'b101011: begin // SW
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 2'b00;
            end
            6'b000100: begin // BEQ
                branch = 1'b1;
                alu_op = 2'b01;
            end
            default: begin
            end
        endcase
    end

endmodule
