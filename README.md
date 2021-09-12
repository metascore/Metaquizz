# Metaquizz

A simple example to integrate a game with Metascore using Stoic identity or Plug identity.

This repo is a complete example of how to create a game that integrates with <a href="https://github.com/metascore/metascore" target="_blank">Metascore</a>

Here's the link to the application on mainnet : https://kjrcp-oqaaa-aaaah-aargq-cai.ic0.app/#/
(Recommended to use Plug to connect for the moment, we are still working on getting everything right for Stoic)

## Steps to follow

1. You should use Stoic identity or Plug to associate players between different games.

2. Your game should implement the Metascore <a href="https://github.com/metascore/metascore/blob/main/src/Metascore.mo" target="_blank"> Game interface </a>. You can use Vessel package manager to easily use the Metascore package. TODO : MORE INFOS.

3. Your game should keep track of it own scores.

4. Your game should register himself to the Metascore canister.

5. Have fun and enjoy seeing your players getting new high scores 🔥.

## Overview

Your game is responsible for publishing scores to the Metascore Can (mainnet principal rl4ub-oqaaa-aaaah-qbi3a-cai) and keeping its metadata in that canister up to date.
Here's the minimum interface your game should implement :

```motoko
public type GameInterface = actor {
    metascoreScores : query () -> async [Score];
    metascoreRegisterSelf : shared (RegisterCallback) -> async ();
};
```

## How to register with Metascore ?

Once your game canister has implemented the `Metascore.GameInterface` you just need to call the `metascoreRegisterSelf` on your canister.

Here's the function `metascoreRegisterSelf` your game canister should implement (part of the game Interface we saw before).

```motoko

// REQUIRED function to integrate with Metascore.
// Metascore will call this function when registering your canister, or when requesting updated metadata.

    public shared func metascoreRegisterSelf(callback : Metascore.RegisterCallback) : async () {
        await callback({
            name = "Your super game!";
        });
    };

```

Here's the command for your terminal to register.

```shell
dfx canister --network ic call metagame register
```

## What should you do to keep scores updated ?

Your Game canister should keep a list of scores of all players and make it available through the `metascoreRegisterSelf` function (part of the game Interface we saw before). This function will be called periodically by the Metascore canister so you should keep the scores list up to date!

```motoko

    // Your canister is responsible for storing its own full list of scores.
    // Metascore will only store the highest score for each player.

    public type Score = (Player,Nat);
    stable var scores : [Metascore.Score] = [];

    // REQUIRED function to integrate with Metascore.
    // Metascore will call this method upon registration and around once per day.

    public query func metascoreScores() : async [Metascore.Score] {
        scores;
    };

```

## Video

Coming soon.. explaining everything there is to know.
