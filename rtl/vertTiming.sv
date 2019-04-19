`timescale 1ns / 1ps

module vertTiming(
    input logic pixelClk,
    input logic rst,
    output logic vclk,
    output logic dataValid
    );

    typedef enum logic [3:0] {frontPorch = 4'b0001, sync = 4'b0010, backPorch = 4'b0100, video = 4'b1000} state_type;

    state_type currState, nextState;

    logic [18:0] currCount, nextCount;

    always_ff @(posedge pixelClk or negedge rst) begin : proc_state
        if(~rst) begin
            currState <= frontPorch;
            currCount <= 0;
        end else begin
            currState <= nextState;
            currCount <= nextCount;
        end
    end

    always_comb begin
        nextState = currState;
        nextCount = currCount;

        dataValid   = 0;
        vclk        = 1;

        case(currState)
            frontPorch:
            begin
                nextCount = currCount + 1;
                if(currCount == 7999) begin
                    nextCount = 0;
                    nextState = sync;
                end
            end

            sync:
            begin
                vclk = 0;
                nextCount = currCount + 1;
                if(currCount == 1599) begin
                    nextCount = 0;
                    nextState = backPorch;
                end
            end

            backPorch:
            begin
                nextCount = currCount + 1;
                if(currCount == 26399) begin
                    nextCount = 0;
                    nextState = video;
                end
            end

            video:
            begin
                dataValid = 1;
                nextCount = currCount + 1;
                if(currCount == 383999) begin
                    nextCount = 0;
                    nextState = frontPorch;
                end
            end

        endcase // currState
    end
endmodule