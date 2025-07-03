module top_module_tb;

    logic clk, reset, start, stop;
    logic [1:0] vote_input;
    logic [1:0] state;
    logic [7:0] vote0, vote1, vote2, vote3;
    logic [1:0] winner_index;
    logic [7:0] winner_votes;

    top_module dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .vote_input(vote_input),
        .state(state),
        .vote0(vote0),
        .vote1(vote1),
        .vote2(vote2),
        .vote3(vote3),
        .winner_index(winner_index),
        .winner_votes(winner_votes)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Time\tState\tVote0\tVote1\tVote2\tVote3\tWinner\tVotes");
        $monitor("%0t\t%b\t%d\t%d\t%d\t%d\t%d\t%d", $time, state, vote0, vote1, vote2, vote3, winner_index, winner_votes);

        clk = 0;
        reset = 1; start = 0; stop = 0; vote_input = 2'b00;
        #10 reset = 0;

        #10 start = 1; #10 start = 0;

        vote_input = 2'b00; #10;
        vote_input = 2'b00; #10;
        vote_input = 2'b01; #10;
        vote_input = 2'b10; #10;
        vote_input = 2'b10; #10;
        vote_input = 2'b10; #10;

        #10 stop = 1; #10 stop = 0;

        #20 $finish;
    end
endmodule
