module cpu_top (
    input wire clk,
    input wire reset
);

    wire [31:0] pc_current, pc_plus4, pc_next;
    wire [31:0] instr;

    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, write_reg;
    wire [15:0] imm16;

    wire reg_write, mem_read, mem_write, mem_to_reg, alu_src, reg_dst, branch;
    wire [1:0] alu_op;
    wire [3:0] alu_ctrl;

    wire [31:0] read_data1, read_data2;
    wire [31:0] imm32, alu_in2, alu_result, mem_read_data, writeback_data;
    wire [31:0] branch_offset, branch_target;
    wire zero, pc_src;

    assign opcode = instr[31:26];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign imm16  = instr[15:0];
    assign funct  = instr[5:0];

    pc u_pc (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    instr_mem u_instr_mem (
        .addr(pc_current),
        .instr(instr)
    );

    adder u_pc_add (
        .a(pc_current),
        .b(32'd4),
        .y(pc_plus4)
    );

    control_unit u_ctrl (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .branch(branch),
        .alu_op(alu_op)
    );

    reg_file u_reg_file (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg),
        .write_data(writeback_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    sign_extend u_sext (
        .imm16(imm16),
        .imm32(imm32)
    );

    alu_control u_alu_ctrl (
        .alu_op(alu_op),
        .funct(funct),
        .alu_ctrl(alu_ctrl)
    );

    mux2 #(32) u_alu_src_mux (
        .d0(read_data2),
        .d1(imm32),
        .sel(alu_src),
        .y(alu_in2)
    );

    alu u_alu (
        .a(read_data1),
        .b(alu_in2),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    data_mem u_dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(read_data2),
        .read_data(mem_read_data)
    );

    mux2 #(5) u_reg_dst_mux (
        .d0(rt),
        .d1(rd),
        .sel(reg_dst),
        .y(write_reg)
    );

    mux2 #(32) u_wb_mux (
        .d0(alu_result),
        .d1(mem_read_data),
        .sel(mem_to_reg),
        .y(writeback_data)
    );

    shift_left2 u_shift (
        .in(imm32),
        .out(branch_offset)
    );

    adder u_branch_add (
        .a(pc_plus4),
        .b(branch_offset),
        .y(branch_target)
    );

    assign pc_src = branch & zero;

    mux2 #(32) u_pc_mux (
        .d0(pc_plus4),
        .d1(branch_target),
        .sel(pc_src),
        .y(pc_next)
    );

endmodule
