util.AddNetworkString("give_wep")

net.Receive("give_wep", function(_, ply)
    ply:Give("tfa_e11_training")
end)