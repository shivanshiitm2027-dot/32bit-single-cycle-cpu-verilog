`timescale 1ns/1ps

module tb_cpu;

    reg clk;
    reg reset;

    cpu_top dut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 1'b0;
        reset = 1'b1;

        // Data memory init
        dut.u_dmem.mem[0] = 32'd10; // addr 0
        dut.u_dmem.mem[1] = 32'd20; // addr 4
        dut.u_dmem.mem[2] = 32'd0;  // addr 8

        // Program
        dut.u_instr_mem.mem[0] = 32'h8C010000; // LW  R1, 0(R0)
        dut.u_instr_mem.mem[1] = 32'h8C020004; // LW  R2, 4(R0)
        dut.u_instr_mem.mem[2] = 32'h00221820; // ADD R3, R1, R2
        dut.u_instr_mem.mem[3] = 32'hAC030008; // SW  R3, 8(R0)
        dut.u_instr_mem.mem[4] = 32'h10210001; // BEQ R1, R1, +1
        dut.u_instr_mem.mem[5] = 32'h00222025; // OR  R4, R1, R2 (skipped)
        dut.u_instr_mem.mem[6] = 32'h00412822; // SUB R5, R2, R1
        dut.u_instr_mem.mem[7] = 32'h00000000;

        #15 reset = 1'b0;
        #100;

        $display("R1 = %0d", dut.u_reg_file.regs[1]);
        $display("R2 = %0d", dut.u_reg_file.regs[2]);
        $display("R3 = %0d", dut.u_reg_file.regs[3]);
        $display("R4 = %0d", dut.u_reg_file.regs[4]);
        $display("R5 = %0d", dut.u_reg_file.regs[5]);
        $display("MEM[2] = %0d", dut.u_dmem.mem[2]);

        $finish;
    end

    initial begin
        $monitor("T=%0t PC=%h INSTR=%h ALU=%0d MEMRD=%0d",
                 $time, dut.u_pc.pc_current, dut.u_instr_mem.instr, dut.u_alu.result, dut.u_dmem.read_data);
    end

endmodule
