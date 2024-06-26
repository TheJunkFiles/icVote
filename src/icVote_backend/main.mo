import Error "mo:base/Error";
import List "mo:base/List";
import Bool "mo:base/Bool";
import Float "mo:base/Float";
import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";

actor bvote {

  type Voter = {
    id : Nat;
    name : Text;
    created_at : Int;
  };

  // var voters : List.List<Voter> = List.nil<Voter>;
  var voters : List.List<Voter> = List.tabulate<Voter>(
    5,
    func(i : Nat) : Voter {
      switch (i) {
        case 0 {
          return {
            id = 1;
            name = "Duke Detain";
            created_at = 1710075025547391000;
          };
        };
        case 1 {
          return {
            id = 2;
            name = "Gabby Tocamera";
            created_at = 1710075025547391000;
          };
        };
        case 2 {
          return {
            id = 3;
            name = "Harl Hubbs";
            created_at = 1710075025547391000;
          };
        };
        case 3 {
          return {
            id = 4;
            name = "Ave Empire";
            created_at = 1710075025547391000;
          };
        };
        case _ {
          return {
            id = 5;
            name = "Little Hubert";
            created_at = 1710075025547391000;
          };
        };
      };
    },
  );

  public func add_voter(id : Nat, name : Text, created_at : Int) : async Voter {
    let new_voter : Voter = {
      id = id;
      name = name;
      created_at = created_at;
    };
    voters := List.push(new_voter, voters);
    return new_voter;
  };

  public func get_voters() : async List.List<Voter> {
    return voters;
  };

  //Function to get voter information based on ID.
  public func get_voter_by_id(voter_id : Nat) : async ?Voter {
    return List.find<Voter>(voters, func(v : Voter) : Bool { v.id == voter_id });
  };

  // Candidate
  public type Candidate = {
    id : Nat;
    name : Text;
    category : Text;
  };

  // Initialize example candidates.
  var candidates : List.List<Candidate> = List.tabulate<Candidate>(
    3,
    func(i : Nat) : Candidate {
      switch (i) {
        case 0 { return { id = 1; name = "Kucing"; category = "Pet" } };
        case 1 { return { id = 2; name = "Hamster"; category = "Pet" } };
        case _ { return { id = 3; name = "Rakun"; category = "Pet" } };
      };
    },
  );

  public func get_candidates() : async List.List<Candidate> {
    return candidates;
  };

  public func get_candidate_by_category(category : Text) : async List.List<Candidate> {
    return List.filter<Candidate>(candidates, func(v : Candidate) : Bool { v.category == category });
  };

  // Vote
  public type Vote = {
    id : Nat;
    candidate_id : Nat;
    category : Text;
    time : Time.Time;
  };

  public func voting_result() : async List.List<Vote> {
    return votes;
  };

  // Simple hash function
  public func hashNIK(nik : Nat) : async Hash.Hash {
    return Hash.hash(nik);
  };

  var votes : List.List<Vote> = List.nil<Vote>();

  // Function to get voter information based on ID
  public func get_current_time() : async Time.Time {
    // Implementation .
    return Time.now();
  };

  public func get_vote_by_id(voter_id : Nat) : async ?Vote {
    return List.find<Vote>(votes, func(v : Vote) : Bool { v.id == voter_id });
  };

  // var Votes: List.List<Vote> = List.tabulate<Vote>(3, func(i : Nat) : Vote {
  // switch (i) {
  //     case 0 { return {id=1234567890; candidate_id=1; category="Pet"; time=123123};};
  //     case 1 { return {id=1234567891; candidate_id=2; category="Pet"; time = 123123};};
  //     case _ { return {id=1234567892; candidate_id=3; category="Pet"; time = 123123};};
  //   };
  // });

  public func commit_vote(voterId : Nat, candidate_id : Nat, category : Text, time : Time.Time) : async Bool {
    let isEligVoter = List.filter(
      voters,
      func(v : Voter) : Bool {
        v.id == voterId;
      },
    );

    let isNotVoted = List.filter(
      votes,
      func(v : Vote) : Bool {
        v.id == voterId;
      },
    );
    // Check if there is at least one voter that matches the criteria.
    if (List.size(isEligVoter) > 0 and List.size(isNotVoted) == 0) {
      // Build updated isVoted status for relevant voters.
      // voters := List.map(voters, func(v: Voter): Voter {
      //     if (v.id == voterId) {
      //         return {id = v.id; name = v.name; isVoted = true};
      //     } else {
      //         return v;
      //     }
      // });

      // Add vote to the list of votes
      let new_vote : Vote = {
        id = voterId;
        candidate_id = candidate_id;
        category = category;
        time = time;
      };
      votes := List.push(new_vote, votes);
      return true; // Voter found and the vote commit process was successful.
    } else {
      return false; // No matching voter or the voter has already voted.
    };
  };
};
