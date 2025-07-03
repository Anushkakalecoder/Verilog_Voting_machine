// FSM to control voting stages
module control_fsm (
    input logic clk, reset, start, stop,
    output logic [1:0] state
);
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        VOTING = 2'b01,
        DONE   = 2'b10
    } state_t;

    state_t current, next;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current <= IDLE;
        else
            current <= next;
    end

    always_comb begin
        next = current;
        case (current)
            IDLE:   if (start) next = VOTING;
            VOTING: if (stop)  next = DONE;
            DONE:   next = DONE;
        endcase
    end

    assign state = current;
endmodule

// Vote counting module (flattened outputs)
module vote_counter (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [1:0] vote_input,
    output logic [7:0] vote0,
    output logic [7:0] vote1,
    output logic [7:0] vote2,
    output logic [7:0] vote3
);
    logic [7:0] counts [3:0];

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counts[0] <= 0;
            counts[1] <= 0;
            counts[2] <= 0;
            counts[3] <= 0;
        end else if (enable) begin
            case (vote_input)
                2'b00: counts[0] <= counts[0] + 1;
                2'b01: counts[1] <= counts[1] + 1;
                2'b10: counts[2] <= counts[2] + 1;
                2'b11: counts[3] <= counts[3] + 1;
            endcase
        end
    end

    assign vote0 = counts[0];
    assign vote1 = counts[1];
    assign vote2 = counts[2];
    assign vote3 = counts[3];
endmodule

// Winner calculation module
module winner_logic (
    input  logic [7:0] vote0, vote1, vote2, vote3,
    output logic [1:0] winner_index,
    output logic [7:0] winner_votes
);
    always_comb begin
        winner_index = 2'd0;
        winner_votes = vote0;

        if (vote1 > winner_votes) begin
            winner_index = 2'd1;
            winner_votes = vote1;
        end
        if (vote2 > winner_votes) begin
            winner_index = 2'd2;
            winner_votes = vote2;
        end
        if (vote3 > winner_votes) begin
            winner_index = 2'd3;
            winner_votes = vote3;
        end
    end
endmodule

// Top integration module
module top_module (
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic stop,
    input  logic [1:0] vote_input,
    output logic [1:0] state,
    output logic [7:0] vote0, vote1, vote2, vote3,
    output logic [1:0] winner_index,
    output logic [7:0] winner_votes
);
    logic enable;

    // FSM
    control_fsm fsm_inst (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .state(state)
    );

    assign enable = (state == 2'b01); // Enable vote only during VOTING

    // Vote counters
    vote_counter vc_inst (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .vote_input(vote_input),
        .vote0(vote0),
        .vote1(vote1),
        .vote2(vote2),
        .vote3(vote3)
    );

    // Winner logic
    logic [1:0] temp_winner;
    logic [7:0] temp_votes;

    winner_logic wl_inst (
        .vote0(vote0),
        .vote1(vote1),
        .vote2(vote2),
        .vote3(vote3),
        .winner_index(temp_winner),
        .winner_votes(temp_votes)
    );

    // Show winner only in DONE state
    assign winner_index = (state == 2'b10) ? temp_winner : 2'bxx;
    assign winner_votes = (state == 2'b10) ? temp_votes  : 8'hxx;
endmodule
