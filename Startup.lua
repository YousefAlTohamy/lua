--#region Shortcuts

J = Utils.Joaat
F = string.format
I = table.insert
U = table.unpack
S = tostring
N = tonumber

--#endregion

--#region Generic

SCRIPT_NAME = "Silent Night"
SCRIPT_VER  = "1.0.0"
DISCORD     = "https://discord.gg/AYpT8cBaVb"
INT32_MAX   = 2147483647
PLAYER_ID   = GTA.GetLocalPlayerId()
GTA_EDITION = Cherax.GetEdition()
MENU_PATH   = FileMgr.GetMenuRootPath()
CONFIG_DIR  = F("%s\\Lua\\SilentNight\\Data\\Config", MENU_PATH)
TRANS_DIR   = F("%s\\Lua\\SilentNight\\Data\\Translations", MENU_PATH)
CAYO_DIR    = F("%s\\Lua\\SilentNight\\Data\\Presets\\CayoPerico", MENU_PATH)
DIAMOND_DIR = F("%s\\Lua\\SilentNight\\Data\\Presets\\DiamondCasino", MENU_PATH)
STATS_DIR   = F("%s\\Lua\\SilentNight\\Data\\Stats", MENU_PATH)
CONFIG_PATH = F("%s\\config.json", CONFIG_DIR)
NPOPULARITY = "TEMP"
TEMP_GLOBAL = "TEMP"
TEMP_LOCAL  = "TEMP"
TEMP_STAT   = "TEMP"
TEMP_PSTAT  = "TEMP"

--#endregion

--#region Logger

_Log = Logger.Log

function Logger.Log(color, str)
    _Log(color, SCRIPT_NAME, str)
end

function Logger.LogError(str)
    _Log(eLogColor.LIGHTRED, SCRIPT_NAME, str)
end

function Logger.LogInfo(str)
    _Log(eLogColor.LIGHTGREEN, SCRIPT_NAME, str)
end

--#endregion

--#region GUI

_AddToast = GUI.AddToast

function GUI.AddToast(text)
    _AddToast(SCRIPT_NAME, CleanToast(text), 5000, eToastPos.TOP_RIGHT)
end

function CleanToast(text)
    local cleaned = text:gsub("^%[.-%]%s*", "")
    cleaned = cleaned:gsub("%s*ツ", ".")
    cleaned = cleaned:gsub("%..$", ".")
    return cleaned
end

--#endregion

--#region SilentLogger

SilentLogger = {}

function SilentLogger.Log(color, str)
    if CONFIG.logging == 0 then
        return
    elseif CONFIG.logging == 1 then
        Logger.Log(color, str)
    elseif CONFIG.logging == 2 or not CONFIG then
        Logger.Log(color, str)
        GUI.AddToast(str)
    end
end

function SilentLogger.LogError(str)
    if CONFIG.logging == 0 then
        return
    elseif CONFIG.logging == 1 then
        Logger.LogError(str)
    elseif CONFIG.logging == 2 or not CONFIG then
        Logger.LogError(str)
        GUI.AddToast(str)
    end
end

function SilentLogger.LogInfo(str)
    if CONFIG.logging == 0 then
        return
    elseif CONFIG.logging == 1 then
        Logger.LogInfo(str)
    elseif CONFIG.logging == 2 or not CONFIG then
        Logger.LogInfo(str)
        GUI.AddToast(str)
    end
end

--#endregion
--#region Natives

function Natives.Invoke(returnType, hash)
    return function(...)
        return Natives[F("Invoke%s", returnType)](hash, ...)
    end
end

--#endregion

--#region eTunable

eTunable = {
    HAS_PARSED = false,

    Business = {
        Bunker = {
            Product = {
                Value             = { type = "int", tunable = "GR_MANU_PRODUCT_VALUE",                   defaultValue = 5000 },
                StaffUpgraded     = { type = "int", tunable = "GR_MANU_PRODUCT_VALUE_STAFF_UPGRADE",     defaultValue = 1000 },
                EquipmentUpgraded = { type = "int", tunable = "GR_MANU_PRODUCT_VALUE_EQUIPMENT_UPGRADE", defaultValue = 1000 }
            },

            Research = {
                Capacity       = { type = "int", tunable = "GR_RESEARCH_CAPACITY",        defaultValue = 60     },
                ProductionTime = { type = "int", tunable = "GR_RESEARCH_PRODUCTION_TIME", defaultValue = 300000 },

                ReductionTime = {
                    EquipmentUpgraded = { type = "int", tunable = "GR_RESEARCH_UPGRADE_EQUIPMENT_REDUCTION_TIME", defaultValue = 45000 },
                    StaffUpgraded     = { type = "int", tunable = "GR_RESEARCH_UPGRADE_STAFF_REDUCTION_TIME",     defaultValue = 45000 }
                },

                MaterialProduct = {
                    Cost         = { type = "int", tunable = "GR_RESEARCH_MATERIAL_PRODUCT_COST",                   defaultValue = 2 },
                    CostUpgraded = { type = "int", tunable = "GR_RESEARCH_MATERIAL_PRODUCT_COST_UPGRADE_REDUCTION", defaultValue = 1 }
                }
            },

            Multiplier = {
                ProductLocal = { type = "float", tunable = "BIKER_SELL_PRODUCT_LOCAL_MODIFIER", defaultValue = 1.0 },
                ProductFar   = { type = "float", tunable = "BIKER_SELL_PRODUCT_FAR_MODIFIER",   defaultValue = 1.5 }
            }
        },

        CrateWarehouse = {
            Price = {
                Threshold1  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD1",  defaultValue = 10000 },
                Threshold2  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD2",  defaultValue = 11000 },
                Threshold3  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD3",  defaultValue = 12000 },
                Threshold4  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD4",  defaultValue = 13000 },
                Threshold5  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD5",  defaultValue = 13500 },
                Threshold6  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD6",  defaultValue = 14000 },
                Threshold7  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD7",  defaultValue = 14500 },
                Threshold8  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD8",  defaultValue = 15000 },
                Threshold9  = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD9",  defaultValue = 15500 },
                Threshold10 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD10", defaultValue = 16000 },
                Threshold11 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD11", defaultValue = 16500 },
                Threshold12 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD12", defaultValue = 17000 },
                Threshold13 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD13", defaultValue = 17500 },
                Threshold14 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD14", defaultValue = 17750 },
                Threshold15 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD15", defaultValue = 18000 },
                Threshold16 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD16", defaultValue = 18250 },
                Threshold17 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD17", defaultValue = 18500 },
                Threshold18 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD18", defaultValue = 18750 },
                Threshold19 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD19", defaultValue = 19000 },
                Threshold20 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD20", defaultValue = 19500 },
                Threshold21 = { type = "int", tunable = "EXEC_CONTRABAND_SALE_VALUE_THRESHOLD21", defaultValue = 20000 }
            },

            Cooldown = {
                Buy  = { type = "int", tunable = "EXEC_BUY_COOLDOWN",  defaultValue = 300000  },
                Sell = { type = "int", tunable = "EXEC_SELL_COOLDOWN", defaultValue = 1800000 }
            },

            HighDemand = { type = "float", tunable = "EXEC_CONTRABAND_HIGH_DEMAND_BONUS_PERCENTAGE", defaultValue = 2.5 }
        },

        Hangar = {
            Price    = { type = "int",   tunable = "SMUG_SELL_PRICE_PER_CRATE_MIXED", defaultValue = 30000 },
            RonsCut  = { type = "float", tunable = "SMUG_SELL_RONS_CUT",              defaultValue = 0.025 },

            Cooldown = {
                Steal = {
                    Easy       = { type = "int", tunable = "SMUG_STEAL_EASY_COOLDOWN_TIMER",            defaultValue = 120000 },
                    Medium     = { type = "int", tunable = "SMUG_STEAL_MED_COOLDOWN_TIMER",             defaultValue = 180000 },
                    Hard       = { type = "int", tunable = "SMUG_STEAL_HARD_COOLDOWN_TIMER",            defaultValue = 240000 },
                    Additional = { type = "int", tunable = "SMUG_STEAL_ADDITIONAL_CRATE_COOLDOWN_TIME", defaultValue = 60000  }
                },

                Sell = { type = "int", tunable = "SMUG_SELL_SELL_COOLDOWN_TIMER", defaultValue = 180000 }
            }
        },

        Nightclub = {
            Price = {
                Weapons   = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_WEAPONS",          defaultValue = 5000  },
                Coke      = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_COKE",             defaultValue = 27000 },
                Meth      = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_METH",             defaultValue = 11475 },
                Weed      = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_WEED",             defaultValue = 2025  },
                Documents = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_FORGED_DOCUMENTS", defaultValue = 1350  },
                Cash      = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_COUNTERFEIT_CASH", defaultValue = 4725  },
                Cargo     = { type = "int", tunable = "BB_BUSINESS_BASIC_VALUE_CARGO",            defaultValue = 10000 }
            },

            Safe = {
                Income = {
                    Top5   = { type = "int", tunable = "NIGHTCLUBINCOMEUPTOPOP5",   defaultValue = 1500  },
                    Top100 = { type = "int", tunable = "NIGHTCLUBINCOMEUPTOPOP100", defaultValue = 50000 }
                },

                MaxCapacity = { type = "int", tunable = "NIGHTCLUBMAXSAFEVALUE", defaultValue = 250000 },
            },

            Cooldown = {
                ClubManagement = { type = "int", tunable = "BB_CLUB_MANAGEMENT_CLUB_MANAGEMENT_MISSION_COOLDOWN",           defaultValue  = 300000 },
                Sell           = { type = "int", tunable = "BB_SELL_MISSIONS_MISSION_COOLDOWN",                             defaultValue  = 300000 },
                SellDelivery   = { type = "int", tunable = "BB_SELL_MISSIONS_DELIVERY_VEHICLE_COOLDOWN_AFTER_SELL_MISSION", defaultValue  = 300000 }
            }
        }
    },

    Heist = {
        Agency = {
            Payout   = { type = "int", tunable = "FIXER_FINALE_LEADER_CASH_REWARD", defaultValue = 1000000 },

            Cooldown = {
                Story    = { type = "int", tunable = "FIXER_STORY_COOLDOWN_POSIX",             defaultValue = 1800   },
                Security = { type = "int", tunable = "FIXER_SECURITY_CONTRACT_COOLDOWN_TIME",  defaultValue = 300000 },
                Payphone = { type = "int", tunable = "REQUEST_FRANKLIN_PAYPHONE_HIT_COOLDOWN", defaultValue = 600000 }
            }
        },

        Apartment = {
            RootIdHash = {
                Fleeca  = { type = "int", tunable = "ROOT_ID_HASH_THE_FLECCA_JOB",           defaultValue = J("33TxqLipLUintwlU_YDzMg") },
                Prison  = { type = "int", tunable = "ROOT_ID_HASH_THE_PRISON_BREAK",         defaultValue = J("A6UBSyF61kiveglc58lm2Q") },
                Humane  = { type = "int", tunable = "ROOT_ID_HASH_THE_HUMANE_LABS_RAID",     defaultValue = J("a_hWnpMUz0-7Yd_Rc5pJ4w") },
                Series  = { type = "int", tunable = "ROOT_ID_HASH_SERIES_A_FUNDING",         defaultValue = J("7r5AKL5aB0qe9HiDy3nW8w") },
                Pacific = { type = "int", tunable = "ROOT_ID_HASH_THE_PACIFIC_STANDARD_JOB", defaultValue = J("hKSf9RCT8UiaZlykyGrMwg") }
            }
        },

        AutoShop = {
            Payout = {
                First   = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD0", defaultValue = 300000 },
                Second  = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD1", defaultValue = 185000 },
                Third   = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD2", defaultValue = 178000 },
                Fourth  = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD3", defaultValue = 172000 },
                Fifth   = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD4", defaultValue = 175000 },
                Sixth   = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD5", defaultValue = 182000 },
                Seventh = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD6", defaultValue = 180000 },
                Eight   = { type = "int",   tunable = "TUNER_ROBBERY_LEADER_CASH_REWARD7", defaultValue = 170000 },
                Fee     = { type = "float", tunable = "TUNER_ROBBERY_CONTACT_FEE",         defaultValue = 0.1    }
            },

            Cooldown = { type = "int", tunable = "TUNER_ROBBERY_COOLDOWN_TIME", defaultValue = 3600 }
        },

        CayoPerico = {
            Bag = {
                MaxCapacity = { type = "int", tunable = "HEIST_BAG_MAX_CAPACITY", defaultValue = 1800 }
            },

            Cut = {
                Pavel = { type = "float", tunable = "IH_DEDUCTION_PAVEL_CUT",   defaultValue = -0.02 },
                Fee   = { type = "float", tunable = "IH_DEDUCTION_FENCING_FEE", defaultValue = -0.1  }
            }
        },

        DiamondCasino = {
            Cut = {
                Lester = { type = "int", tunable = "CH_LESTER_CUT", defaultValue = 5 },

                Gunman = {
                    Karl    = { type = "int", tunable = "HEIST3_PREPBOARD_GUNMEN_KARL_CUT",    defaultValue = 5  },
                    Gustavo = { type = "int", tunable = "HEIST3_PREPBOARD_GUNMEN_GUSTAVO_CUT", defaultValue = 9  },
                    Charlie = { type = "int", tunable = "HEIST3_PREPBOARD_GUNMEN_CHARLIE_CUT", defaultValue = 7  },
                    Chester = { type = "int", tunable = "HEIST3_PREPBOARD_GUNMEN_CHESTER_CUT", defaultValue = 10 },
                    Patrick = { type = "int", tunable = "HEIST3_PREPBOARD_GUNMEN_PATRICK_CUT", defaultValue = 8  }
                },

                Driver = {
                    Karim   = { type = "int", tunable = "HEIST3_DRIVERS_KARIM_CUT",   defaultValue = 5  },
                    Taliana = { type = "int", tunable = "HEIST3_DRIVERS_TALIANA_CUT", defaultValue = 7  },
                    Eddie   = { type = "int", tunable = "HEIST3_DRIVERS_EDDIE_CUT",   defaultValue = 9  },
                    Norm    = { type = "int", tunable = "HEIST3_DRIVERS_ZACH_CUT",    defaultValue = 6  },
                    Chester = { type = "int", tunable = "HEIST3_DRIVERS_CHESTER_CUT", defaultValue = 10 }
                },

                Hacker = {
                    Rickie    = { type = "int", tunable = "HEIST3_HACKERS_RICKIE_CUT",    defaultValue = 3  },
                    Christian = { type = "int", tunable = "HEIST3_HACKERS_CHRISTIAN_CUT", defaultValue = 7  },
                    Yohan     = { type = "int", tunable = "HEIST3_HACKERS_YOHAN_CUT",     defaultValue = 5  },
                    Avi       = { type = "int", tunable = "HEIST3_HACKERS_AVI_CUT",       defaultValue = 10 },
                    Paige     = { type = "int", tunable = "HEIST3_HACKERS_PAIGE_CUT",     defaultValue = 9  }
                }
            },

            Buyer = {
                Low  = { type = "float", tunable = "CH_BUYER_MOD_SHORT", defaultValue = 0.9  },
                Mid  = { type = "float", tunable = "CH_BUYER_MOD_MED",   defaultValue = 0.95 },
                High = { type = "float", tunable = "CH_BUYER_MOD_LONG",  defaultValue = 1    }
            }
        },

        SalvageYard = {
            Robbery = {
                SetupPrice = { type = "int", tunable = 71522671, defaultValue = 20000 }
            },

            Vehicle = {
                ClaimPrice = {
                    Standard   = { type = "int", tunable = "SALV23_VEHICLE_CLAIM_PRICE",                  defaultValue = 20000 },
                    Discounted = { type = "int", tunable = "SALV23_VEHICLE_CLAIM_PRICE_FORGERY_DISCOUNT", defaultValue = 10000 }
                }
            },

            Cooldown = {
                Weekly  = { type = "int", tunable = "SALV23_VEH_ROBBERY_WEEK_ID",   defaultValue = 0    },
                Robbery = { type = "int", tunable = "SALV23_VEH_ROB_COOLDOWN_TIME", defaultValue = 300  },
                Cfr     = { type = "int", tunable = "SALV23_CFR_COOLDOWN_TIME",     defaultValue = 3600 }
            }
        },
    },

    World = {
        Casino = {
            Chips = {
                Limit = {
                    Acquire          = { type = "int", tunable = "VC_CASINO_CHIP_MAX_BUY",           defaultValue = 20000    },
                    AcquirePenthouse = { type = "int", tunable = "VC_CASINO_CHIP_MAX_BUY_PENTHOUSE", defaultValue = 50000    },
                    Sell             = { type = "int", tunable = "VC_CASINO_CHIP_MAX_SELL",          defaultValue = 10000000 }
                }
            }
        }
    }
}

--#endregion

--#region eGlobal

if GTA_EDITION == "EE" then
    eGlobal = {
        HAS_PARSED = false,

        Heist = {
            Generic = {
                Launch = {
                    Step1 = { type = "int", global = 4718592 + 3539       },
                    Step2 = { type = "int", global = 4718592 + 3540       },
                    Step3 = { type = "int", global = 4718592 + 3542 + 1   },
                    Step4 = { type = "int", global = 4718592 + 190507 + 1 }
                },

                Cut = { type = "int", global = 2685690 + 6753 }
            },

            Apartment = {
                Cut = {
                    Player1 = {
                        Global = { type = "int", global = 1931800 + 1 + 1    },
                        Local  = { type = "int", global = 1933768 + 3008 + 1 }
                    },

                    Player2 = {
                        Global = { type = "int", global = 1931800 + 1 + 2    },
                        Local  = { type = "int", global = 1933768 + 3008 + 2 }
                    },

                    Player3 = {
                        Global = { type = "int", global = 1931800 + 1 + 3    },
                        Local  = { type = "int", global = 1933768 + 3008 + 3 }
                    },

                    Player4 = {
                        Global = { type = "int", global = 1931800 + 1 + 4    },
                        Local  = { type = "int", global = 1933768 + 3008 + 4 }
                    }
                },

                Ready = {
                    Player1 = { type = "int", global = 2658019 + 1 + (0 * 467) + 269 },
                    Player2 = { type = "int", global = 2658019 + 1 + (1 * 467) + 269 },
                    Player3 = { type = "int", global = 2658019 + 1 + (2 * 467) + 269 },
                    Player4 = { type = "int", global = 2658019 + 1 + (3 * 467) + 269 }
                },

                Reload   = { type = "int", global = 1931835                             },
                Cooldown = { type = "int", global = 1877086 + 1 + (PLAYER_ID * 77) + 76 },

                Heist = {
                    Type       = { type = "int", global = 1877086 + (PLAYER_ID * 77) + 24 + 2 },
                    Difficulty = { type = "int", global = 4718592 + 3538                      }
                }
            },

            CayoPerico = {
                Cut = {
                    Player1 = { type = "int", global = 1973698 + 831 + 56 + 1 },
                    Player2 = { type = "int", global = 1973698 + 831 + 56 + 2 },
                    Player3 = { type = "int", global = 1973698 + 831 + 56 + 3 },
                    Player4 = { type = "int", global = 1973698 + 831 + 56 + 4 }
                },

                Ready = {
                    Player1 = { type = "int", global = 1974810 + 1 + (0 * 27) + 7 + 1 },
                    Player2 = { type = "int", global = 1974810 + 1 + (1 * 27) + 7 + 2 },
                    Player3 = { type = "int", global = 1974810 + 1 + (2 * 27) + 7 + 3 },
                    Player4 = { type = "int", global = 1974810 + 1 + (3 * 27) + 7 + 4 }
                }
            },

            DiamondCasino = {
                Cut = {
                    Player1 = { type = "int", global = 1966898 + 1497 + 736 + 92 + 1 },
                    Player2 = { type = "int", global = 1966898 + 1497 + 736 + 92 + 2 },
                    Player3 = { type = "int", global = 1966898 + 1497 + 736 + 92 + 3 },
                    Player4 = { type = "int", global = 1966898 + 1497 + 736 + 92 + 4 }
                },

                Ready = {
                    Player1 = { type = "int", global = 1971261 + 1 + (0 * 68) + 7 + 1 },
                    Player2 = { type = "int", global = 1971261 + 1 + (1 * 68) + 7 + 2 },
                    Player3 = { type = "int", global = 1971261 + 1 + (2 * 68) + 7 + 3 },
                    Player4 = { type = "int", global = 1971261 + 1 + (3 * 68) + 7 + 4 }
                }
            },

            Doomsday = {
                Cut = {
                    Player1 = { type = "int", global = 1962078 + 812 + 50 + 1 },
                    Player2 = { type = "int", global = 1962078 + 812 + 50 + 2 },
                    Player3 = { type = "int", global = 1962078 + 812 + 50 + 3 },
                    Player4 = { type = "int", global = 1962078 + 812 + 50 + 4 }
                },

                Ready = {
                    Player1 = { type = "int", global = 1882925 + 1 + (0 * 149) + 43 + 11 + 1 },
                    Player2 = { type = "int", global = 1882925 + 1 + (1 * 149) + 43 + 11 + 2 },
                    Player3 = { type = "int", global = 1882925 + 1 + (2 * 149) + 43 + 11 + 3 },
                    Player4 = { type = "int", global = 1882925 + 1 + (3 * 149) + 43 + 11 + 4 },
                }
            },

            SalvageYard = {
                Robbery = {
                    Slot1 = {
                        Type = { type = "int", global = 262145 + 33524 + 1 }
                    },

                    Slot2 = {
                        Type = { type = "int", global = 262145 + 33524 + 2 }
                    },

                    Slot3 = {
                        Type = { type = "int", global = 262145 + 33524 + 3 }
                    }
                },

                Vehicle = {
                    Slot1 = {
                        Type    = { type = "int",  global = 262145 + 33532 + 1 },
                        Value   = { type = "int",  global = 262145 + 33536 + 1 },
                        CanKeep = { type = "bool", global = 262145 + 33528 + 1 }
                    },

                    Slot2 = {
                        Type    = { type = "int",  global = 262145 + 33532 + 2 },
                        Value   = { type = "int",  global = 262145 + 33536 + 2 },
                        CanKeep = { type = "bool", global = 262145 + 33528 + 2 }
                    },

                    Slot3 = {
                        Type    = { type = "int",  global = 262145 + 33532 + 3 },
                        Value   = { type = "int",  global = 262145 + 33536 + 3 },
                        CanKeep = { type = "bool", global = 262145 + 33528 + 3 }
                    },

                    SalvageValueMultiplier = { type = "float", global = 262145 + 33544 }
                }
            }
        },

        Business = {
            Base = {
                OrbitalCannon = {
                    Refund = { type = "int", global = 1963562 }
                }
            },

            Bunker = {
                Production = {
                    Trigger1 = { type = "int",  global = 2708294 + 1 + 5 * 2     },
                    Trigger2 = { type = "bool", global = 2708294 + 1 + 5 * 2 + 1 }
                },

                Multiplier = { type = "float", global = 262145 + 18879 }
            },

            Nightclub = {
                Safe = {
                    Income = {
                        Top5   = { type = "int", global = 262145 + 23661 },
                        Top100 = { type = "int", global = 262145 + 23680 }
                    },

                    Value = { type = "int", global = 1845274 + 1 + (PLAYER_ID * 892) + 268 + 360 + 5 }
                }
            },

            Supplies = {
                Slot0  = { type = "int", global = 1668007 + 0 + 1 },
                Slot1  = { type = "int", global = 1668007 + 1 + 1 },
                Slot2  = { type = "int", global = 1668007 + 2 + 1 },
                Slot3  = { type = "int", global = 1668007 + 3 + 1 },
                Slot4  = { type = "int", global = 1668007 + 4 + 1 },
                Bunker = { type = "int", global = 1668007 + 5 + 1 },
                Acid   = { type = "int", global = 1668007 + 6 + 1 }
            }
        },

        Player = {
            Cash = {
                Remove = { type = "int", global = 2708037 + 36 }
            }
        },

        Session = {
            Type   = { type = "int", global = 1575040     },
            Switch = { type = "int", global = 1574589     },
            Quit   = { type = "int", global = 1574589 + 2 }
        },

        World = {
            Casino = {
                Chips = {
                    Bonus = { type = "int", global = 1968565 }
                }
            },

            GunVan = {
                Location = { type = "int", global = 2652587 + 2706 + 1 }
            },

            Multiplier = {
                Cash = { type = "float", global = 262145     },
                Xp   = { type = "float", global = 262145 + 1 }
            }
        }
    }
else
    eGlobal = {
        HAS_PARSED = false,

        Heist = {
            Generic = {
                Launch = {
                    Step1 = { type = "int", global = 4718592 + 3539       },
                    Step2 = { type = "int", global = 4718592 + 3540       },
                    Step3 = { type = "int", global = 4718592 + 3542 + 1   },
                    Step4 = { type = "int", global = 4718592 + 184007 + 1 }
                },

                Cut = { type = "int", global = 2685685 + 6742 }
            },

            Apartment = {
                Cut = {
                    Player1 = {
                        Global = { type = "int", global = 1931323 + 1 + 1    },
                        Local  = { type = "int", global = 1933291 + 3008 + 1 }
                    },

                    Player2 = {
                        Global = { type = "int", global = 1931323 + 1 + 2    },
                        Local  = { type = "int", global = 1933291 + 3008 + 2 }
                    },

                    Player3 = {
                        Global = { type = "int", global = 1931323 + 1 + 3    },
                        Local  = { type = "int", global = 1933291 + 3008 + 3 }
                    },

                    Player4 = {
                        Global = { type = "int", global = 1931323 + 1 + 4    },
                        Local  = { type = "int", global = 1933291 + 3008 + 4 }
                    }
                },

                Ready = {
                    Player1 = { type = "int", global = 2657991 + 1 + (0 * 467) + 269 },
                    Player2 = { type = "int", global = 2657991 + 1 + (1 * 467) + 269 },
                    Player3 = { type = "int", global = 2657991 + 1 + (2 * 467) + 269 },
                    Player4 = { type = "int", global = 2657991 + 1 + (3 * 467) + 269 }
                },

                Reload   = { type = "int", global = 1931358                             },
                Cooldown = { type = "int", global = 1876941 + 1 + (PLAYER_ID * 77) + 76 },

                Heist = {
                    Type       = { type = "int", global = 1876941 + (PLAYER_ID * 77) + 24 + 2 },
                    Difficulty = { type = "int", global = 4718592 + 3525                      }
                }

            },

            CayoPerico = {
                Cut = {
                    Player1 = { type = "int", global = 1974520 + 831 + 56 + 1 },
                    Player2 = { type = "int", global = 1974520 + 831 + 56 + 2 },
                    Player3 = { type = "int", global = 1974520 + 831 + 56 + 3 },
                    Player4 = { type = "int", global = 1974520 + 831 + 56 + 4 }
                },

                Ready = {
                    Player1 = { type = "int", global = 1975632 + 1 + (0 * 27) + 7 + 1 },
                    Player2 = { type = "int", global = 1975632 + 1 + (1 * 27) + 7 + 2 },
                    Player3 = { type = "int", global = 1975632 + 1 + (2 * 27) + 7 + 3 },
                    Player4 = { type = "int", global = 1975632 + 1 + (3 * 27) + 7 + 4 }
                }
            },

            DiamondCasino = {
                Cut = {
                    Player1 = { type = "int", global = 1967717 + 1497 + 736 + 92 + 1 },
                    Player2 = { type = "int", global = 1967717 + 1497 + 736 + 92 + 2 },
                    Player3 = { type = "int", global = 1967717 + 1497 + 736 + 92 + 3 },
                    Player4 = { type = "int", global = 1967717 + 1497 + 736 + 92 + 4 }
                },

                Ready = {
                    Player1 = { type = "int", global = 1972080 + 1 + (0 * 68) + 7 + 1 },
                    Player2 = { type = "int", global = 1972080 + 1 + (1 * 68) + 7 + 2 },
                    Player3 = { type = "int", global = 1972080 + 1 + (2 * 68) + 7 + 3 },
                    Player4 = { type = "int", global = 1972080 + 1 + (3 * 68) + 7 + 4 }
                }
            },

            Doomsday = {
                Cut = {
                    Player1 = { type = "int", global = 1963610 + 812 + 50 + 1 },
                    Player2 = { type = "int", global = 1963610 + 812 + 50 + 2 },
                    Player3 = { type = "int", global = 1963610 + 812 + 50 + 3 },
                    Player4 = { type = "int", global = 1963610 + 812 + 50 + 4 }
                },

                Ready = {
                    Player1 = { type = "int", global = 1882304 + 1 + (0 * 146) + 43 + 11 + 1 },
                    Player2 = { type = "int", global = 1882304 + 1 + (1 * 146) + 43 + 11 + 2 },
                    Player3 = { type = "int", global = 1882304 + 1 + (2 * 146) + 43 + 11 + 3 },
                    Player4 = { type = "int", global = 1882304 + 1 + (3 * 146) + 43 + 11 + 4 },
                }
            },

            SalvageYard = {
                Robbery = {
                    Slot1 = {
                        Type = { type = "int", global = 262145 + 33022 + 1 }
                    },

                    Slot2 = {
                        Type = { type = "int", global = 262145 + 33022 + 2 }
                    },

                    Slot3 = {
                        Type = { type = "int", global = 262145 + 33022 + 3 }
                    }
                },

                Vehicle = {
                    Slot1 = {
                        Type    = { type = "int",  global = 262145 + 33030 + 1 },
                        Value   = { type = "int",  global = 262145 + 33034 + 1 },
                        CanKeep = { type = "bool", global = 262145 + 33026 + 1 }
                    },

                    Slot2 = {
                        Type    = { type = "int",  global = 262145 + 33030 + 2 },
                        Value   = { type = "int",  global = 262145 + 33034 + 2 },
                        CanKeep = { type = "bool", global = 262145 + 33026 + 2 }
                    },

                    Slot3 = {
                        Type    = { type = "int",  global = 262145 + 33030 + 3 },
                        Value   = { type = "int",  global = 262145 + 33034 + 3 },
                        CanKeep = { type = "bool", global = 262145 + 33026 + 3 }
                    },

                    SalvageValueMultiplier = { type = "float", global = 262145 + 33042 }
                }
            }
        },

        Business = {
            Base = {
                OrbitalCannon = {
                    Refund = { type = "int", global = 1962995 }
                }
            },

            Bunker = {
                Production = {
                    Trigger1 = { type = "int",  global = 2708158 + 1 + 5 * 2     },
                    Trigger2 = { type = "bool", global = 2708158 + 1 + 5 * 2 + 1 }
                },

                Multiplier = { type = "float", global = 262145 + 18875 }
            },

            Nightclub = {
                Safe = {
                    Income = {
                        Top5   = { type = "int", global = 262145 + 23657 },
                        Top100 = { type = "int", global = 262145 + 23676 }
                    },

                    Value = { type = "int", global = 1845225 + 1 + (PLAYER_ID * 889) + 268 + 360 + 5 }
                }
            },

            Supplies = {
                Slot0  = { type = "int", global = 1668000 + 0 + 1 },
                Slot1  = { type = "int", global = 1668000 + 1 + 1 },
                Slot2  = { type = "int", global = 1668000 + 2 + 1 },
                Slot3  = { type = "int", global = 1668000 + 3 + 1 },
                Slot4  = { type = "int", global = 1668000 + 4 + 1 },
                Bunker = { type = "int", global = 1668000 + 5 + 1 },
                Acid   = { type = "int", global = 1668000 + 6 + 1 }
            }
        },

        Player = {
            Cash = {
                Remove = { type = "int", global = 2707922 + 36 }
            }
        },

        Session = {
            Type   = { type = "int", global = 1575038     },
            Switch = { type = "int", global = 1574589     },
            Quit   = { type = "int", global = 1574589 + 2 }
        },

        World = {
            Casino = {
                Chips = {
                    Bonus = { type = "int", global = 1967286 }
                }
            },

            GunVan = {
                Location = { type = "int", global = 2652584 + 2706 + 1 }
            },

            Multiplier = {
                Cash = { type = "float", global = 262145     },
                Xp   = { type = "float", global = 262145 + 1 }
            }
        }
    }
end

--#endregion

--#region eLocal

if GTA_EDITION == "EE" then
    eLocal = {
        HAS_PARSED = false,

        Business = {
            Bunker = {
                Sell = {
                    Finish = { type = "int", vLocal = 1266 + 774, script = "gb_gunrunning" }
                }
            },

            CrateWarehouse = {
                Buy = {
                    Amount  = { type = "int", vLocal = 625 + 1,   script = "gb_contraband_buy" },
                    Finish1 = { type = "int", vLocal = 625 + 5,   script = "gb_contraband_buy" },
                    Finish2 = { type = "int", vLocal = 625 + 191, script = "gb_contraband_buy" },
                    Finish3 = { type = "int", vLocal = 625 + 192, script = "gb_contraband_buy" }
                },

                Sell = {
                    Type   = { type = "int", vLocal = 567 + 7, script = "gb_contraband_sell" },
                    Finish = { type = "int", vLocal = 567 + 1, script = "gb_contraband_sell" }
                }
            },

            Hangar = {
                Sell = {
                    Delivered = { type = "int", vLocal = 1987 + 1078, script = "gb_smuggler" },
                    Finish    = { type = "int", vLocal = 1987 + 1035, script = "gb_smuggler" }
                }
            },

            Nightclub = {
                Safe = {
                    Type    = { type = "int", vLocal = 204 + 32 + 2,      script = "am_mp_nightclub" },
                    Collect = { type = "int", vLocal = 204 + 32 + 19 + 1, script = "am_mp_nightclub" }
                }
            }
        },

        Heist = {
            Generic = {
                Launch = {
                    Step1 = { type = "int", vLocal = 19992 + 15, script = "fmmc_launcher" },
                    Step2 = { type = "int", vLocal = 19992 + 34, script = "fmmc_launcher" },
                },

                Skip = {
                    Old = { type = "int", vLocal = 20391 + 2, script = "fm_mission_controller"      },
                    New = { type = "int", vLocal = 54763 + 2, script = "fm_mission_controller_2020" },
                },

                Finish  = {
                    Old = {
                        Step1 = { type = "int", vLocal = 20391 + 1062,     script = "fm_mission_controller" },
                        Step2 = { type = "int", vLocal = 20391 + 1232 + 1, script = "fm_mission_controller" },
                        Step3 = { type = "int", vLocal = 20391 + 1,        script = "fm_mission_controller" }
                    },

                    New = {
                        Step1 = { type = "int", vLocal = 54763 + 1589,     script = "fm_mission_controller_2020" },
                        Step2 = { type = "int", vLocal = 54763 + 1776 + 1, script = "fm_mission_controller_2020" },
                        Step3 = { type = "int", vLocal = 54763 + 1,        script = "fm_mission_controller_2020" }
                    }
                }
            },

            Agency = {
                Finish = {
                    Step1 = { type = "int", vLocal = 54763 + 1,        script = "fm_mission_controller_2020" },
                    Step2 = { type = "int", vLocal = 54763 + 1776 + 1, script = "fm_mission_controller_2020" }
                }
            },

            Apartment = {
                Bypass = {
                    Fleeca = {
                        Hack  = { type = "int",   vLocal = 12220 + 24, script = "fm_mission_controller" },
                        Drill = { type = "float", vLocal = 10509 + 11, script = "fm_mission_controller" }
                    },

                    Pacific = {
                        Hack = { type = "int", vLocal = 10213, script = "fm_mission_controller" }
                    }
                },

                Finish = {
                    Step1 = { type = "int", vLocal = 20391,            script = "fm_mission_controller" },
                    Step2 = { type = "int", vLocal = 20391 + 1062,     script = "fm_mission_controller" },
                    Step3 = { type = "int", vLocal = 20391 + 1740 + 1, script = "fm_mission_controller" },
                    Step4 = { type = "int", vLocal = 20391 + 2686,     script = "fm_mission_controller" },
                    Step5 = { type = "int", vLocal = 29011 + 1,        script = "fm_mission_controller" },
                    Step6 = { type = "int", vLocal = 32467 + 1 + 68,   script = "fm_mission_controller" }
                }
            },

            AutoShop = {
                Reload = { type = "int", vLocal = 406, script = "tuner_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 54763 + 1,        script = "fm_mission_controller_2020" },
                    Step2 = { type = "int", vLocal = 54763 + 1776 + 1, script = "fm_mission_controller_2020" }
                }
            },

            CayoPerico = {
                Bypass = {
                    FingerprintHack = { type = "int",   vLocal = 25460,     script = "fm_mission_controller_2020" },
                    PlasmaCutterCut = { type = "float", vLocal = 31525 + 3, script = "fm_mission_controller_2020" },
                    DrainagePipeCut = { type = "int",   vLocal = 30285,     script = "fm_mission_controller_2020" },
                },

                Reload = { type = "int", vLocal = 1568, script = "heist_island_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 54763,            script = "fm_mission_controller_2020" },
                    Step2 = { type = "int", vLocal = 54763 + 1776 + 1, script = "fm_mission_controller_2020" }
                }
            },

            DiamondCasino = {
                Autograbber = {
                    Grab  = { type =   "int", vLocal = 10695,      script = "fm_mission_controller" },
                    Speed = { type = "float", vLocal = 10695 + 14, script = "fm_mission_controller" }
                },

                Bypass = {
                    FingerprintHack = { type = "int", vLocal = 54037,      script = "fm_mission_controller" },
                    KeypadHack      = { type = "int", vLocal = 55103,      script = "fm_mission_controller" },
                    VaultDrill1     = { type = "int", vLocal = 10509 + 7,  script = "fm_mission_controller" },
                    VaultDrill2     = { type = "int", vLocal = 10509 + 37, script = "fm_mission_controller" }
                },

                Reload = { type = "int", vLocal = 210, script = "gb_casino_heist_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 20391,            script = "fm_mission_controller" },
                    Step2 = { type = "int", vLocal = 20391 + 1062,     script = "fm_mission_controller" },
                    Step3 = { type = "int", vLocal = 20391 + 1740 + 1, script = "fm_mission_controller" },
                    Step4 = { type = "int", vLocal = 20391 + 2686,     script = "fm_mission_controller" },
                    Step5 = { type = "int", vLocal = 29011 + 1,        script = "fm_mission_controller" },
                    Step6 = { type = "int", vLocal = 32467 + 1 + 68,   script = "fm_mission_controller" }
                }
            },

            Doomsday = {
                Bypass = {
                    DataHack     = { type = "int", vLocal = 1539,       script = "fm_mission_controller" },
                    DoomsdayHack = { type = "int", vLocal = 1296 + 135, script = "fm_mission_controller" }
                },

                Reload = { type = "int", vLocal = 209, script = "gb_gang_ops_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 20391,            script = "fm_mission_controller" },
                    Step2 = { type = "int", vLocal = 20391 + 1740 + 1, script = "fm_mission_controller" },
                    Step3 = { type = "int", vLocal = 29011 + 1,        script = "fm_mission_controller" },
                    Step4 = { type = "int", vLocal = 32467 + 1 + 68,   script = "fm_mission_controller" },
                    Step5 = { type = "int", vLocal = 32467 + 97,       script = "fm_mission_controller" }
                }
            },

            SalvageYard = {
                Reload = { type = "int", vLocal = 535, script = "vehrob_planning" }
            }
        },

        World = {
            Casino = {
                Blackjack = {
                    Dealer = {
                        FirstCard  = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 1, script = "blackjack" },
                        SecondCard = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 2, script = "blackjack" },
                        ThirdCard  = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 3, script = "blackjack" }
                    },

                    CurrentTable = { type = "int", vLocal = 1798 + 1 + (PLAYER_ID * 8) + 4,                                                                 script = "blackjack" },
                    VisibleCards = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 12, script = "blackjack" }
                },

                LuckyWheel = {
                    WinState    = { type = "int", vLocal = 302 + 14, script = "casino_lucky_wheel" },
                    PrizeState  = { type = "int", vLocal = 302 + 45, script = "casino_lucky_wheel" }
                },

                Poker = {
                    CurrentTable  = { type = "int", vLocal = 769 + 1 + (PLAYER_ID * 9) + 2, script = "three_card_poker" },
                    Table         = { type = "int", vLocal = 769,                           script = "three_card_poker" },
                    TableSize     = { type = "int", vLocal = 9,                             script = "three_card_poker" },
                    Cards         = { type = "int", vLocal = 136,                           script = "three_card_poker" },
                    CurrentDeck   = { type = "int", vLocal = 168,                           script = "three_card_poker" },
                    AntiCheat     = { type = "int", vLocal = 1058,                          script = "three_card_poker" },
                    AntiCheatDeck = { type = "int", vLocal = 799,                           script = "three_card_poker" },
                    DeckSize      = { type = "int", vLocal = 55,                            script = "three_card_poker" }
                },

                Roulette = {
                    MasterTable   = { type = "int", vLocal = 146,  script = "casinoroulette" },
                    OutcomesTable = { type = "int", vLocal = 1357, script = "casinoroulette" },
                    BallTable     = { type = "int", vLocal = 153,  script = "casinoroulette" }
                },

                Slots = {
                    RandomResultTable = { type = "int", vLocal = 1370, script = "casino_slots" }
                }
            }
        }
    }
else
    eLocal = {
        HAS_PARSED = false,

        Business = {
            Bunker = {
                Sell = {
                    Finish = { type = "int", vLocal = 1264 + 774, script = "gb_gunrunning" }
                }
            },

            CrateWarehouse = {
                Buy = {
                    Amount  = { type = "int", vLocal = 623 + 1,   script = "gb_contraband_buy" },
                    Finish1 = { type = "int", vLocal = 623 + 5,   script = "gb_contraband_buy" },
                    Finish2 = { type = "int", vLocal = 623 + 191, script = "gb_contraband_buy" },
                    Finish3 = { type = "int", vLocal = 623 + 192, script = "gb_contraband_buy" }
                },

                Sell = {
                    Type   = { type = "int", vLocal = 565 + 7, script = "gb_contraband_sell" },
                    Finish = { type = "int", vLocal = 565 + 1, script = "gb_contraband_sell" }
                }
            },

            Hangar = {
                Sell = {
                    Delivered = { type = "int", vLocal = 1985 + 1078, script = "gb_smuggler" },
                    Finish    = { type = "int", vLocal = 1985 + 1035, script = "gb_smuggler" }
                }
            },

            Nightclub = {
                Safe = {
                    Type    = { type = "int", vLocal = 202 + 32 + 4, script = "am_mp_nightclub" },
                    Collect = { type = "int", vLocal = 202 + 32 + 1, script = "am_mp_nightclub" }
                }
            }
        },

        Heist = {
            Generic = {
                Launch = {
                    Step1 = { type = "int", vLocal = 19990 + 15, script = "fmmc_launcher" },
                    Step2 = { type = "int", vLocal = 19990 + 34, script = "fmmc_launcher" },
                },

                Skip = {
                    Old = { type = "int", vLocal = 19787 + 2, script = "fm_mission_controller"      },
                    New = { type = "int", vLocal = 54353 + 2, script = "fm_mission_controller_2020" },
                },

                Finish  = {
                    Old = {
                        Step1 = { type = "int", vLocal = 19787 + 1062,     script = "fm_mission_controller" },
                        Step2 = { type = "int", vLocal = 19787 + 1232 + 1, script = "fm_mission_controller" },
                        Step3 = { type = "int", vLocal = 19787 + 1,        script = "fm_mission_controller" }
                    },

                    New = {
                        Step1 = { type = "int", vLocal = 54353 + 1589,     script = "fm_mission_controller_2020" },
                        Step2 = { type = "int", vLocal = 54353 + 1776 + 1, script = "fm_mission_controller_2020" },
                        Step3 = { type = "int", vLocal = 54353 + 1,        script = "fm_mission_controller_2020" }
                    }
                }
            },

            Agency = {
                Finish = {
                    Step1 = { type = "int", vLocal = 54353 + 1,        script = "fm_mission_controller_2020" },
                    Step2 = { type = "int", vLocal = 54353 + 1776 + 1, script = "fm_mission_controller_2020" }
                }
            },

            Apartment = {
                Bypass = {
                    Fleeca = {
                        Hack  = { type = "int",   vLocal = 11818 + 24, script = "fm_mission_controller" },
                        Drill = { type = "float", vLocal = 10107 + 11, script = "fm_mission_controller" }
                    },

                    Pacific = {
                        Hack = { type = "int", vLocal = 9811, script = "fm_mission_controller" }
                    }
                },

                Finish = {
                    Step1 = { type = "int", vLocal = 19787,            script = "fm_mission_controller" },
                    Step2 = { type = "int", vLocal = 19787 + 1062,     script = "fm_mission_controller" },
                    Step3 = { type = "int", vLocal = 19787 + 1740 + 1, script = "fm_mission_controller" },
                    Step4 = { type = "int", vLocal = 19787 + 2686,     script = "fm_mission_controller" },
                    Step5 = { type = "int", vLocal = 28407 + 1,        script = "fm_mission_controller" },
                    Step6 = { type = "int", vLocal = 31663 + 1 + 68,   script = "fm_mission_controller" }
                }
            },

            AutoShop = {
                Reload  = { type = "int", vLocal = 404, script = "tuner_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 54353 + 1,        script = "fm_mission_controller_2020" },
                    Step2 = { type = "int", vLocal = 54353 + 1776 + 1, script = "fm_mission_controller_2020" }
                }
            },

            CayoPerico = {
                Bypass = {
                    FingerprintHack = { type = "int",   vLocal = 25058,     script = "fm_mission_controller_2020" },
                    PlasmaCutterCut = { type = "float", vLocal = 31123 + 3, script = "fm_mission_controller_2020" },
                    DrainagePipeCut = { type = "int",   vLocal = 29883,     script = "fm_mission_controller_2020" },
                },

                Reload = { type = "int", vLocal = 1566, script = "heist_island_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 54353,            script = "fm_mission_controller_2020" },
                    Step2 = { type = "int", vLocal = 54353 + 1776 + 1, script = "fm_mission_controller_2020" }
                }
            },

            DiamondCasino = {
                Autograbber = {
                    Grab  = { type =   "int", vLocal = 10293,      script = "fm_mission_controller" },
                    Speed = { type = "float", vLocal = 10293 + 14, script = "fm_mission_controller" }
                },

                Bypass = {
                    FingerprintHack = { type = "int", vLocal = 53127,      script = "fm_mission_controller" },
                    KeypadHack      = { type = "int", vLocal = 54193,      script = "fm_mission_controller" },
                    VaultDrill1     = { type = "int", vLocal = 10107 + 7,  script = "fm_mission_controller" },
                    VaultDrill2     = { type = "int", vLocal = 10107 + 37, script = "fm_mission_controller" }
                },

                Reload = { type = "int", vLocal = 208, script = "gb_casino_heist_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 19787,            script = "fm_mission_controller" },
                    Step2 = { type = "int", vLocal = 19787 + 1062,     script = "fm_mission_controller" },
                    Step3 = { type = "int", vLocal = 19787 + 1740 + 1, script = "fm_mission_controller" },
                    Step4 = { type = "int", vLocal = 19787 + 2686,     script = "fm_mission_controller" },
                    Step5 = { type = "int", vLocal = 28407 + 1,        script = "fm_mission_controller" },
                    Step6 = { type = "int", vLocal = 31663 + 1 + 68,   script = "fm_mission_controller" }
                }
            },

            Doomsday = {
                Bypass = {
                    DataHack     = { type = "int", vLocal = 1537,       script = "fm_mission_controller" },
                    DoomsdayHack = { type = "int", vLocal = 1294 + 135, script = "fm_mission_controller" }
                },

                Reload = { type = "int", vLocal = 207, script = "gb_gang_ops_planning" },

                Finish = {
                    Step1 = { type = "int", vLocal = 19787,            script = "fm_mission_controller" },
                    Step2 = { type = "int", vLocal = 19787 + 1740 + 1, script = "fm_mission_controller" },
                    Step3 = { type = "int", vLocal = 28407 + 1,        script = "fm_mission_controller" },
                    Step4 = { type = "int", vLocal = 31663 + 1 + 68,   script = "fm_mission_controller" },
                    Step5 = { type = "int", vLocal = 31663 + 97,       script = "fm_mission_controller" }
                }
            },

            SalvageYard = {
                Reload = { type = "int", vLocal = 533, script = "vehrob_planning" }
            }
        },

        World = {
            Casino = {
                Blackjack = {
                    Dealer = {
                        FirstCard  = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 1,  script = "blackjack" },
                        SecondCard = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 2,  script = "blackjack" },
                        ThirdCard  = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 3,  script = "blackjack" }
                    },

                    CurrentTable = { type = "int", vLocal = 1796 + 1 + (PLAYER_ID * 8) + 4,                                                                 script = "blackjack" },
                    VisibleCards = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4)) * 13 + 12, script = "blackjack" }
                },

                LuckyWheel = {
                    WinState    = { type = "int", vLocal = 300 + 14, script = "casino_lucky_wheel" },
                    PrizeState  = { type = "int", vLocal = 300 + 45, script = "casino_lucky_wheel" }
                },

                Poker = {
                    CurrentTable  = { type = "int", vLocal = 769 + 1 + (PLAYER_ID * 9) + 2, script = "three_card_poker" },
                    Table         = { type = "int", vLocal = 769,                           script = "three_card_poker" },
                    TableSize     = { type = "int", vLocal = 9,                             script = "three_card_poker" },
                    Cards         = { type = "int", vLocal = 136,                           script = "three_card_poker" },
                    CurrentDeck   = { type = "int", vLocal = 168,                           script = "three_card_poker" },
                    AntiCheat     = { type = "int", vLocal = 1058,                          script = "three_card_poker" },
                    AntiCheatDeck = { type = "int", vLocal = 799,                           script = "three_card_poker" },
                    DeckSize      = { type = "int", vLocal = 55,                            script = "three_card_poker" }
                },

                Roulette = {
                    MasterTable   = { type = "int", vLocal = 144,  script = "casinoroulette" },
                    OutcomesTable = { type = "int", vLocal = 1357, script = "casinoroulette" },
                    BallTable     = { type = "int", vLocal = 153,  script = "casinoroulette" }
                },

                Slots = {
                    RandomResultTable = { type = "int", vLocal = 1368, script = "casino_slots" }
                }
            }
        }
    }
end

--#endregion
--#region eStat

eStat = {
    HAS_PARSED = false,

    MPPLY_LAST_MP_CHAR              = { type = "int",   stat = "MPPLY_LAST_MP_CHAR"             },
    SP0_TOTAL_CASH                  = { type = "int",   stat = "SP0_TOTAL_CASH"                 },
    SP1_TOTAL_CASH                  = { type = "int",   stat = "SP1_TOTAL_CASH"                 },
    SP2_TOTAL_CASH                  = { type = "int",   stat = "SP2_TOTAL_CASH"                 },
    MPX_H3_LAST_APPROACH            = { type = "int",   stat = "H3_LAST_APPROACH"               },
    MPX_H3_HARD_APPROACH            = { type = "int",   stat = "H3_HARD_APPROACH"               },
    MPX_H3_APPROACH                 = { type = "int",   stat = "H3_APPROACH"                    },
    MPX_H3OPT_APPROACH              = { type = "int",   stat = "H3OPT_APPROACH"                 },
    MPX_GANGOPS_FLOW_MISSION_PROG   = { type = "int",   stat = "GANGOPS_FLOW_MISSION_PROG"      },
    MPX_GANGOPS_HEIST_STATUS        = { type = "int",   stat = "GANGOPS_HEIST_STATUS"           },
    MPX_GANGOPS_FLOW_NOTIFICATIONS  = { type = "int",   stat = "GANGOPS_FLOW_NOTIFICATIONS"     },
    MPX_SCGW_INITIALS_0             = { type = "int",   stat = "SCGW_INITIALS_0"                },
    MPX_SCGW_INITIALS_1             = { type = "int",   stat = "SCGW_INITIALS_1"                },
    MPX_SCGW_INITIALS_2             = { type = "int",   stat = "SCGW_INITIALS_2"                },
    MPX_SCGW_INITIALS_3             = { type = "int",   stat = "SCGW_INITIALS_3"                },
    MPX_SCGW_INITIALS_4             = { type = "int",   stat = "SCGW_INITIALS_4"                },
    MPX_SCGW_INITIALS_5             = { type = "int",   stat = "SCGW_INITIALS_5"                },
    MPX_SCGW_INITIALS_6             = { type = "int",   stat = "SCGW_INITIALS_6"                },
    MPX_SCGW_INITIALS_7             = { type = "int",   stat = "SCGW_INITIALS_7"                },
    MPX_SCGW_INITIALS_8             = { type = "int",   stat = "SCGW_INITIALS_8"                },
    MPX_SCGW_INITIALS_9             = { type = "int",   stat = "SCGW_INITIALS_9"                },
    MPX_FOOTAGE_INITIALS_0          = { type = "int",   stat = "FOOTAGE_INITIALS_0"             },
    MPX_FOOTAGE_INITIALS_1          = { type = "int",   stat = "FOOTAGE_INITIALS_1"             },
    MPX_FOOTAGE_INITIALS_2          = { type = "int",   stat = "FOOTAGE_INITIALS_2"             },
    MPX_FOOTAGE_INITIALS_3          = { type = "int",   stat = "FOOTAGE_INITIALS_3"             },
    MPX_FOOTAGE_INITIALS_4          = { type = "int",   stat = "FOOTAGE_INITIALS_4"             },
    MPX_FOOTAGE_INITIALS_5          = { type = "int",   stat = "FOOTAGE_INITIALS_5"             },
    MPX_FOOTAGE_INITIALS_6          = { type = "int",   stat = "FOOTAGE_INITIALS_6"             },
    MPX_FOOTAGE_INITIALS_7          = { type = "int",   stat = "FOOTAGE_INITIALS_7"             },
    MPX_FOOTAGE_INITIALS_8          = { type = "int",   stat = "FOOTAGE_INITIALS_8"             },
    MPX_FOOTAGE_INITIALS_9          = { type = "int",   stat = "FOOTAGE_INITIALS_9"             },
    MPX_FOOTAGE_SCORE_0             = { type = "int",   stat = "FOOTAGE_SCORE_0"                },
    MPX_FOOTAGE_SCORE_1             = { type = "int",   stat = "FOOTAGE_SCORE_1"                },
    MPX_FOOTAGE_SCORE_2             = { type = "int",   stat = "FOOTAGE_SCORE_2"                },
    MPX_FOOTAGE_SCORE_3             = { type = "int",   stat = "FOOTAGE_SCORE_3"                },
    MPX_FOOTAGE_SCORE_4             = { type = "int",   stat = "FOOTAGE_SCORE_4"                },
    MPX_FOOTAGE_SCORE_5             = { type = "int",   stat = "FOOTAGE_SCORE_5"                },
    MPX_FOOTAGE_SCORE_6             = { type = "int",   stat = "FOOTAGE_SCORE_6"                },
    MPX_FOOTAGE_SCORE_7             = { type = "int",   stat = "FOOTAGE_SCORE_7"                },
    MPX_FOOTAGE_SCORE_8             = { type = "int",   stat = "FOOTAGE_SCORE_8"                },
    MPX_FOOTAGE_SCORE_9             = { type = "int",   stat = "FOOTAGE_SCORE_9"                },
    MPPLY_BADSPORT_MESSAGE          = { type = "int",   stat = "MPPLY_BADSPORT_MESSAGE"         },
    MPPLY_BECAME_BADSPORT_NUM       = { type = "int",   stat = "MPPLY_BECAME_BADSPORT_NUM"      },
    MPX_H4LOOT_PAINT                = { type = "int",   stat = "H4LOOT_PAINT"                   },
    MPX_H4LOOT_PAINT_SCOPED         = { type = "int",   stat = "H4LOOT_PAINT_SCOPED"            },
    MPX_H4LOOT_PAINT_V              = { type = "int",   stat = "H4LOOT_PAINT_V"                 },
    MPX_CLUB_PAY_TIME_LEFT          = { type = "int",   stat = "CLUB_PAY_TIME_LEFT"             },
    MPX_ALLOW_GENDER_CHANGE         = { type = "int",   stat = "ALLOW_GENDER_CHANGE"            },
    MPX_NUMBER_SLIPSTREAMS_IN_RACE  = { type = "int",   stat = "NUMBER_SLIPSTREAMS_IN_RACE"     },
    MPX_AWD_FM_DM_WINS              = { type = "int",   stat = "AWD_FM_DM_WINS"                 },
    MPX_AWD_FM_TDM_WINS             = { type = "int",   stat = "AWD_FM_TDM_WINS"                },
    MPX_AWD_FM_TDM_MVP              = { type = "int",   stat = "AWD_FM_TDM_MVP"                 },
    MPX_AWD_RACES_WON               = { type = "int",   stat = "AWD_RACES_WON"                  },
    MPX_AWD_FM_GTA_RACES_WON        = { type = "int",   stat = "AWD_FM_GTA_RACES_WON"           },
    MPX_AWD_FM_RACES_FASTEST_LAP    = { type = "int",   stat = "AWD_FM_RACES_FASTEST_LAP"       },
    MPX_NUMBER_TURBO_STARTS_IN_RACE = { type = "int",   stat = "NUMBER_TURBO_STARTS_IN_RACE"    },
    MPX_AWD_CARS_EXPORTED           = { type = "int",   stat = "AWD_CARS_EXPORTED"              },
    MPX_AWD_WIN_CAPTURES            = { type = "int",   stat = "AWD_WIN_CAPTURES"               },
    MPX_AWD_WIN_LAST_TEAM_STANDINGS = { type = "int",   stat = "AWD_WIN_LAST_TEAM_STANDINGS"    },
    MPX_AWD_ONLY_PLAYER_ALIVE_LTS   = { type = "int",   stat = "AWD_ONLY_PLAYER_ALIVE_LTS"      },
    MPX_AWD_FMWINAIRRACE            = { type = "int",   stat = "AWD_FMWINAIRRACE"               },
    MPX_AWD_FMWINSEARACE            = { type = "int",   stat = "AWD_FMWINSEARACE"               },
    MPX_AWD_NO_ARMWRESTLING_WINS    = { type = "int",   stat = "AWD_NO_ARMWRESTLING_WINS"       },
    MPX_MOST_ARM_WRESTLING_WINS     = { type = "int",   stat = "MOST_ARM_WRESTLING_WINS"        },
    MPX_AWD_WIN_AT_DARTS            = { type = "int",   stat = "AWD_WIN_AT_DARTS"               },
    MPX_AWD_FM_GOLF_WON             = { type = "int",   stat = "AWD_FM_GOLF_WON"                },
    MPX_AWD_FM_TENNIS_WON           = { type = "int",   stat = "AWD_FM_TENNIS_WON"              },
    MPX_AWD_FM_SHOOTRANG_CT_WON     = { type = "int",   stat = "AWD_FM_SHOOTRANG_CT_WON"        },
    MPX_AWD_FM_SHOOTRANG_RT_WON     = { type = "int",   stat = "AWD_FM_SHOOTRANG_RT_WON"        },
    MPX_AWD_FM_SHOOTRANG_TG_WON     = { type = "int",   stat = "AWD_FM_SHOOTRANG_TG_WON"        },
    MPX_AWD_WIN_CAPTURE_DONT_DYING  = { type = "int",   stat = "AWD_WIN_CAPTURE_DONT_DYING"     },
    MPX_AWD_KILL_TEAM_YOURSELF_LTS  = { type = "int",   stat = "AWD_KILL_TEAM_YOURSELF_LTS"     },
    MPX_AIR_LAUNCHES_OVER_40M       = { type = "int",   stat = "AIR_LAUNCHES_OVER_40M"          },
    MPX_AWD_LESTERDELIVERVEHICLES   = { type = "int",   stat = "AWD_LESTERDELIVERVEHICLES"      },
    MPX_AWD_FMRALLYWONDRIVE         = { type = "int",   stat = "AWD_FMRALLYWONDRIVE"            },
    MPX_AWD_FMRALLYWONNAV           = { type = "int",   stat = "AWD_FMRALLYWONNAV"              },
    MPX_AWD_FMWINRACETOPOINTS       = { type = "int",   stat = "AWD_FMWINRACETOPOINTS"          },
    MPX_AWD_FM_RACE_LAST_FIRST      = { type = "int",   stat = "AWD_FM_RACE_LAST_FIRST"         },
    MPX_AWD_FMHORDWAVESSURVIVE      = { type = "int",   stat = "AWD_FMHORDWAVESSURVIVE"         },
    MPPLY_FM_MISSION_LIKES          = { type = "int",   stat = "MPPLY_FM_MISSION_LIKES"         },
    MPPLY_SHOOTINGRANGE_TOTAL_MATCH = { type = "int",   stat = "MPPLY_SHOOTINGRANGE_TOTAL_MATCH"},
    MPPLY_DARTS_TOTAL_MATCHES       = { type = "int",   stat = "MPPLY_DARTS_TOTAL_MATCHES"      },
    MPPLY_TOTAL_TDEATHMATCH_WON     = { type = "int",   stat = "MPPLY_TOTAL_TDEATHMATCH_WON"    },
    MPPLY_DARTS_TOTAL_WINS          = { type = "int",   stat = "MPPLY_DARTS_TOTAL_WINS"         },
    MPPLY_RACE_2_POINT_WINS         = { type = "int",   stat = "MPPLY_RACE_2_POINT_WINS"        },
    MPPLY_MISSIONS_CREATED          = { type = "int",   stat = "MPPLY_MISSIONS_CREATED"         },
    MPPLY_LTS_CREATED               = { type = "int",   stat = "MPPLY_LTS_CREATED"              },
    MPPLY_GOLF_WINS                 = { type = "int",   stat = "MPPLY_GOLF_WINS"                },
    MPPLY_BJ_WINS                   = { type = "int",   stat = "MPPLY_BJ_WINS"                  },
    MPPLY_TENNIS_MATCHES_WON        = { type = "int",   stat = "MPPLY_TENNIS_MATCHES_WON"       },
    MPPLY_SHOOTINGRANGE_WINS        = { type = "int",   stat = "MPPLY_SHOOTINGRANGE_WINS"       },
    MPPLY_TOTAL_DEATHMATCH_WON      = { type = "int",   stat = "MPPLY_TOTAL_DEATHMATCH_WON"     },
    MPPLY_TOTAL_CUSTOM_RACES_WON    = { type = "int",   stat = "MPPLY_TOTAL_CUSTOM_RACES_WON"   },
    MPPLY_TOTAL_RACES_WON           = { type = "int",   stat = "MPPLY_TOTAL_RACES_WON"          },
    MPPLY_TOTAL_RACES_LOST          = { type = "int",   stat = "MPPLY_TOTAL_RACES_LOST"         },
    MPPLY_TOTAL_DEATHMATCH_LOST     = { type = "int",   stat = "MPPLY_TOTAL_DEATHMATCH_LOST"    },
    MPPLY_TOTAL_TDEATHMATCH_LOST    = { type = "int",   stat = "MPPLY_TOTAL_TDEATHMATCH_LOST"   },
    MPPLY_SHOOTINGRANGE_LOSSES      = { type = "int",   stat = "MPPLY_SHOOTINGRANGE_LOSSES"     },
    MPPLY_TENNIS_MATCHES_LOST       = { type = "int",   stat = "MPPLY_TENNIS_MATCHES_LOST"      },
    MPPLY_GOLF_LOSSES               = { type = "int",   stat = "MPPLY_GOLF_LOSSES"              },
    MPPLY_BJ_LOST                   = { type = "int",   stat = "MPPLY_BJ_LOST"                  },
    MPPLY_RACE_2_POINT_LOST         = { type = "int",   stat = "MPPLY_RACE_2_POINT_LOST"        },
    MPPLY_KILLS_PLAYERS             = { type = "int",   stat = "MPPLY_KILLS_PLAYERS"            },
    MPPLY_DEATHS_PLAYER             = { type = "int",   stat = "MPPLY_DEATHS_PLAYER"            },
    MPX_AWD_FMBBETWIN               = { type = "int",   stat = "AWD_FMBBETWIN"                  },
    MPX_BOUNTPLACED                 = { type = "int",   stat = "BOUNTPLACED"                    },
    MPX_BETAMOUNT                   = { type = "int",   stat = "BETAMOUNT"                      },
    MPX_CRARMWREST                  = { type = "int",   stat = "CRARMWREST"                     },
    MPX_CRBASEJUMP                  = { type = "int",   stat = "CRBASEJUMP"                     },
    MPX_CRDARTS                     = { type = "int",   stat = "CRDARTS"                        },
    MPX_CRDM                        = { type = "int",   stat = "CRDM"                           },
    MPX_CRGANGHIDE                  = { type = "int",   stat = "CRGANGHIDE"                     },
    MPX_CRGOLF                      = { type = "int",   stat = "CRGOLF"                         },
    MPX_CRHORDE                     = { type = "int",   stat = "CRHORDE"                        },
    MPX_CRMISSION                   = { type = "int",   stat = "CRMISSION"                      },
    MPX_CRSHOOTRNG                  = { type = "int",   stat = "CRSHOOTRNG"                     },
    MPX_CRTENNIS                    = { type = "int",   stat = "CRTENNIS"                       },
    MPX_NO_TIMES_CINEMA             = { type = "int",   stat = "NO_TIMES_CINEMA"                },
    MPX_BOUNTSONU                   = { type = "int",   stat = "BOUNTSONU"                      },
    MPX_AWD_DROPOFF_CAP_PACKAGES    = { type = "int",   stat = "AWD_DROPOFF_CAP_PACKAGES"       },
    MPX_AWD_PICKUP_CAP_PACKAGES     = { type = "int",   stat = "AWD_PICKUP_CAP_PACKAGES"        },
    MPX_NO_PHOTOS_TAKEN             = { type = "int",   stat = "NO_PHOTOS_TAKEN"                },
    MPX_AWD_MENTALSTATE_TO_NORMAL   = { type = "int",   stat = "AWD_MENTALSTATE_TO_NORMAL"      },
    MPX_CR_DIFFERENT_DM             = { type = "int",   stat = "CR_DIFFERENT_DM"                },
    MPX_CR_DIFFERENT_RACES          = { type = "int",   stat = "CR_DIFFERENT_RACES"             },
    MPX_AWD_PARACHUTE_JUMPS_20M     = { type = "int",   stat = "AWD_PARACHUTE_JUMPS_20M"        },
    MPX_AWD_PARACHUTE_JUMPS_50M     = { type = "int",   stat = "AWD_PARACHUTE_JUMPS_50M"        },
    MPX_AWD_FMBASEJMP               = { type = "int",   stat = "AWD_FMBASEJMP"                  },
    MPX_AWD_FM_GOLF_BIRDIES         = { type = "int",   stat = "AWD_FM_GOLF_BIRDIES"            },
    MPX_AWD_FM_TENNIS_ACE           = { type = "int",   stat = "AWD_FM_TENNIS_ACE"              },
    MPX_AWD_LAPDANCES               = { type = "int",   stat = "AWD_LAPDANCES"                  },
    MPX_AWD_FMCRATEDROPS            = { type = "int",   stat = "AWD_FMCRATEDROPS"               },
    MPX_AWD_NO_HAIRCUTS             = { type = "int",   stat = "AWD_NO_HAIRCUTS"                },
    MPX_AWD_TRADE_IN_YOUR_PROPERTY  = { type = "int",   stat = "AWD_TRADE_IN_YOUR_PROPERTY"     },
    MPPLY_AWD_FM_CR_MISSION_SCORE   = { type = "int",   stat = "MPPLY_AWD_FM_CR_MISSION_SCORE"  },
    MPPLY_AWD_FM_CR_DM_MADE         = { type = "int",   stat = "MPPLY_AWD_FM_CR_DM_MADE"        },
    MPPLY_AWD_FM_CR_RACES_MADE      = { type = "int",   stat = "MPPLY_AWD_FM_CR_RACES_MADE"     },
    MPPLY_AWD_FM_CR_PLAYED_BY_PEEP  = { type = "int",   stat = "MPPLY_AWD_FM_CR_PLAYED_BY_PEEP" },
    MPX_FIREWORK_TYPE_1_WHITE       = { type = "int",   stat = "FIREWORK_TYPE_1_WHITE"          },
    MPX_FIREWORK_TYPE_1_RED         = { type = "int",   stat = "FIREWORK_TYPE_1_RED"            },
    MPX_FIREWORK_TYPE_1_BLUE        = { type = "int",   stat = "FIREWORK_TYPE_1_BLUE"           },
    MPX_FIREWORK_TYPE_2_WHITE       = { type = "int",   stat = "FIREWORK_TYPE_2_WHITE"          },
    MPX_FIREWORK_TYPE_2_RED         = { type = "int",   stat = "FIREWORK_TYPE_2_RED"            },
    MPX_FIREWORK_TYPE_2_BLUE        = { type = "int",   stat = "FIREWORK_TYPE_2_BLUE"           },
    MPX_FIREWORK_TYPE_3_WHITE       = { type = "int",   stat = "FIREWORK_TYPE_3_WHITE"          },
    MPX_FIREWORK_TYPE_3_RED         = { type = "int",   stat = "FIREWORK_TYPE_3_RED"            },
    MPX_FIREWORK_TYPE_3_BLUE        = { type = "int",   stat = "FIREWORK_TYPE_3_BLUE"           },
    MPX_FIREWORK_TYPE_4_WHITE       = { type = "int",   stat = "FIREWORK_TYPE_4_WHITE"          },
    MPX_FIREWORK_TYPE_4_RED         = { type = "int",   stat = "FIREWORK_TYPE_4_RED"            },
    MPX_FIREWORK_TYPE_4_BLUE        = { type = "int",   stat = "FIREWORK_TYPE_4_BLUE"           },
    MPX_CHAR_WEAP_UNLOCKED          = { type = "int",   stat = "CHAR_WEAP_UNLOCKED"             },
    MPX_CHAR_WEAP_UNLOCKED2         = { type = "int",   stat = "CHAR_WEAP_UNLOCKED2"            },
    MPX_CHAR_WEAP_UNLOCKED3         = { type = "int",   stat = "CHAR_WEAP_UNLOCKED3"            },
    MPX_CHAR_WEAP_UNLOCKED4         = { type = "int",   stat = "CHAR_WEAP_UNLOCKED4"            },
    MPX_CHAR_WEAP_ADDON_1_UNLCK     = { type = "int",   stat = "CHAR_WEAP_ADDON_1_UNLCK"        },
    MPX_CHAR_WEAP_ADDON_2_UNLCK     = { type = "int",   stat = "CHAR_WEAP_ADDON_2_UNLCK"        },
    MPX_CHAR_WEAP_ADDON_3_UNLCK     = { type = "int",   stat = "CHAR_WEAP_ADDON_3_UNLCK"        },
    MPX_CHAR_WEAP_ADDON_4_UNLCK     = { type = "int",   stat = "CHAR_WEAP_ADDON_4_UNLCK"        },
    MPX_CHAR_WEAP_FREE              = { type = "int",   stat = "CHAR_WEAP_FREE"                 },
    MPX_CHAR_WEAP_FREE2             = { type = "int",   stat = "CHAR_WEAP_FREE2"                },
    MPX_CHAR_FM_WEAP_FREE           = { type = "int",   stat = "CHAR_FM_WEAP_FREE"              },
    MPX_CHAR_FM_WEAP_FREE2          = { type = "int",   stat = "CHAR_FM_WEAP_FREE2"             },
    MPX_CHAR_FM_WEAP_FREE3          = { type = "int",   stat = "CHAR_FM_WEAP_FREE3"             },
    MPX_CHAR_FM_WEAP_FREE4          = { type = "int",   stat = "CHAR_FM_WEAP_FREE4"             },
    MPX_CHAR_WEAP_PURCHASED         = { type = "int",   stat = "CHAR_WEAP_PURCHASED"            },
    MPX_CHAR_WEAP_PURCHASED2        = { type = "int",   stat = "CHAR_WEAP_PURCHASED2"           },
    MPX_WEAPON_PICKUP_BITSET        = { type = "int",   stat = "WEAPON_PICKUP_BITSET"           },
    MPX_WEAPON_PICKUP_BITSET2       = { type = "int",   stat = "WEAPON_PICKUP_BITSET2"          },
    MPX_CHAR_FM_WEAP_UNLOCKED       = { type = "int",   stat = "CHAR_FM_WEAP_UNLOCKED"          },
    MPX_NO_WEAPONS_UNLOCK           = { type = "int",   stat = "NO_WEAPONS_UNLOCK"              },
    MPX_NO_WEAPON_MODS_UNLOCK       = { type = "int",   stat = "NO_WEAPON_MODS_UNLOCK"          },
    MPX_NO_WEAPON_CLR_MOD_UNLOCK    = { type = "int",   stat = "NO_WEAPON_CLR_MOD_UNLOCK"       },
    MPX_CHAR_FM_WEAP_UNLOCKED2      = { type = "int",   stat = "CHAR_FM_WEAP_UNLOCKED2"         },
    MPX_CHAR_FM_WEAP_UNLOCKED3      = { type = "int",   stat = "CHAR_FM_WEAP_UNLOCKED3"         },
    MPX_CHAR_FM_WEAP_UNLOCKED4      = { type = "int",   stat = "CHAR_FM_WEAP_UNLOCKED4"         },
    MPX_CHAR_KIT_1_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_1_FM_UNLCK"            },
    MPX_CHAR_KIT_2_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_2_FM_UNLCK"            },
    MPX_CHAR_KIT_3_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_3_FM_UNLCK"            },
    MPX_CHAR_KIT_4_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_4_FM_UNLCK"            },
    MPX_CHAR_KIT_5_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_5_FM_UNLCK"            },
    MPX_CHAR_KIT_6_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_6_FM_UNLCK"            },
    MPX_CHAR_KIT_7_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_7_FM_UNLCK"            },
    MPX_CHAR_KIT_8_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_8_FM_UNLCK"            },
    MPX_CHAR_KIT_9_FM_UNLCK         = { type = "int",   stat = "CHAR_KIT_9_FM_UNLCK"            },
    MPX_CHAR_KIT_10_FM_UNLCK        = { type = "int",   stat = "CHAR_KIT_10_FM_UNLCK"           },
    MPX_CHAR_KIT_11_FM_UNLCK        = { type = "int",   stat = "CHAR_KIT_11_FM_UNLCK"           },
    MPX_CHAR_KIT_12_FM_UNLCK        = { type = "int",   stat = "CHAR_KIT_12_FM_UNLCK"           },
    MPX_CHAR_KIT_FM_PURCHASE        = { type = "int",   stat = "CHAR_KIT_FM_PURCHASE"           },
    MPX_CHAR_WEAP_FM_PURCHASE       = { type = "int",   stat = "CHAR_WEAP_FM_PURCHASE"          },
    MPX_CHAR_WEAP_FM_PURCHASE2      = { type = "int",   stat = "CHAR_WEAP_FM_PURCHASE2"         },
    MPX_CHAR_WEAP_FM_PURCHASE3      = { type = "int",   stat = "CHAR_WEAP_FM_PURCHASE3"         },
    MPX_CHAR_WEAP_FM_PURCHASE4      = { type = "int",   stat = "CHAR_WEAP_FM_PURCHASE4"         },
    MPX_WEAP_FM_ADDON_PURCH         = { type = "int",   stat = "WEAP_FM_ADDON_PURCH"            },
    MPX_CLUBHOUSECONTRACTEARNINGS   = { type = "int",   stat = "CLUBHOUSECONTRACTEARNINGS"      },
    MPX_CHAR_WANTED_LEVEL_TIME5STAR = { type = "int",   stat = "CHAR_WANTED_LEVEL_TIME5STAR"    },
    MPX_STARS_ATTAINED              = { type = "int",   stat = "STARS_ATTAINED"                 },
    MPX_KILLS_COP                   = { type = "int",   stat = "KILLS_COP"                      },
    MPX_STARS_EVADED                = { type = "int",   stat = "STARS_EVADED"                   },
    MPX_KILLS_PLAYERS               = { type = "int",   stat = "KILLS_PLAYERS"                  },
    MPX_DEATHS_PLAYER               = { type = "int",   stat = "DEATHS_PLAYER"                  },
    MPX_MC_CONTRIBUTION_POINTS      = { type = "int",   stat = "MC_CONTRIBUTION_POINTS"         },
    MPX_SHOTS                       = { type = "int",   stat = "SHOTS"                          },
    MPX_CR_GANGATTACK_CITY          = { type = "int",   stat = "CR_GANGATTACK_CITY"             },
    MPX_CR_GANGATTACK_COUNTRY       = { type = "int",   stat = "CR_GANGATTACK_COUNTRY"          },
    MPX_CR_GANGATTACK_LOST          = { type = "int",   stat = "CR_GANGATTACK_LOST"             },
    MPX_CR_GANGATTACK_VAGOS         = { type = "int",   stat = "CR_GANGATTACK_VAGOS"            },
    MPX_DIED_IN_DROWNING            = { type = "int",   stat = "DIED_IN_DROWNING"               },
    MPX_DIED_IN_DROWNINGINVEHICLE   = { type = "int",   stat = "DIED_IN_DROWNINGINVEHICLE"      },
    MPX_DIED_IN_EXPLOSION           = { type = "int",   stat = "DIED_IN_EXPLOSION"              },
    MPX_DIED_IN_FALL                = { type = "int",   stat = "DIED_IN_FALL"                   },
    MPX_DIED_IN_FIRE                = { type = "int",   stat = "DIED_IN_FIRE"                   },
    MPX_DIED_IN_ROAD                = { type = "int",   stat = "DIED_IN_ROAD"                   },
    MPX_KILLS                       = { type = "int",   stat = "KILLS"                          },
    MPX_MEMBERSMARKEDFORDEATH       = { type = "int",   stat = "MEMBERSMARKEDFORDEATH"          },
    MPX_MCDEATHS                    = { type = "int",   stat = "MCDEATHS"                       },
    MPX_RIVALPRESIDENTKILLS         = { type = "int",   stat = "RIVALPRESIDENTKILLS"            },
    MPX_RIVALCEOANDVIPKILLS         = { type = "int",   stat = "RIVALCEOANDVIPKILLS"            },
    MPX_CLUBHOUSECONTRACTSCOMPLETE  = { type = "int",   stat = "CLUBHOUSECONTRACTSCOMPLETE"     },
    MPX_CLUBCHALLENGESCOMPLETED     = { type = "int",   stat = "CLUBCHALLENGESCOMPLETED"        },
    MPX_MEMBERCHALLENGESCOMPLETED   = { type = "int",   stat = "MEMBERCHALLENGESCOMPLETED"      },
    MPX_KILLS_ARMED                 = { type = "int",   stat = "KILLS_ARMED"                    },
    MPX_HORDKILLS                   = { type = "int",   stat = "HORDKILLS"                      },
    MPX_UNIQUECRATES                = { type = "int",   stat = "UNIQUECRATES"                   },
    MPX_BJWINS                      = { type = "int",   stat = "BJWINS"                         },
    MPX_HORDEWINS                   = { type = "int",   stat = "HORDEWINS"                      },
    MPX_MCMWINS                     = { type = "int",   stat = "MCMWINS"                        },
    MPX_GANGHIDWINS                 = { type = "int",   stat = "GANGHIDWINS"                    },
    MPX_GHKILLS                     = { type = "int",   stat = "GHKILLS"                        },
    MPX_TIRES_POPPED_BY_GUNSHOT     = { type = "int",   stat = "TIRES_POPPED_BY_GUNSHOT"        },
    MPX_KILLS_INNOCENTS             = { type = "int",   stat = "KILLS_INNOCENTS"                },
    MPX_KILLS_ENEMY_GANG_MEMBERS    = { type = "int",   stat = "KILLS_ENEMY_GANG_MEMBERS"       },
    MPX_KILLS_FRIENDLY_GANG_MEMBERS = { type = "int",   stat = "KILLS_FRIENDLY_GANG_MEMBERS"    },
    MPX_MCKILLS                     = { type = "int",   stat = "MCKILLS"                        },
    MPX_SNIPERRFL_ENEMY_KILLS       = { type = "int",   stat = "SNIPERRFL_ENEMY_KILLS"          },
    MPX_HVYSNIPER_ENEMY_KILLS       = { type = "int",   stat = "HVYSNIPER_ENEMY_KILLS"          },
    MPX_BIGGEST_VICTIM_KILLS        = { type = "int",   stat = "BIGGEST_VICTIM_KILLS"           },
    MPX_ARCHENEMY_KILLS             = { type = "int",   stat = "ARCHENEMY_KILLS"                },
    MPX_KILLS_SWAT                  = { type = "int",   stat = "KILLS_SWAT"                     },
    MPX_VEHEXPORTED                 = { type = "int",   stat = "VEHEXPORTED"                    },
    MPX_NO_NON_CONTRACT_RACE_WIN    = { type = "int",   stat = "NO_NON_CONTRACT_RACE_WIN"       },
    MPX_MICROSMG_ENEMY_KILLS        = { type = "int",   stat = "MICROSMG_ENEMY_KILLS"           },
    MPX_SMG_ENEMY_KILLS             = { type = "int",   stat = "SMG_ENEMY_KILLS"                },
    MPX_ASLTSMG_ENEMY_KILLS         = { type = "int",   stat = "ASLTSMG_ENEMY_KILLS"            },
    MPX_CRBNRIFLE_ENEMY_KILLS       = { type = "int",   stat = "CRBNRIFLE_ENEMY_KILLS"          },
    MPX_ADVRIFLE_ENEMY_KILLS        = { type = "int",   stat = "ADVRIFLE_ENEMY_KILLS"           },
    MPX_MG_ENEMY_KILLS              = { type = "int",   stat = "MG_ENEMY_KILLS"                 },
    MPX_CMBTMG_ENEMY_KILLS          = { type = "int",   stat = "CMBTMG_ENEMY_KILLS"             },
    MPX_ASLTMG_ENEMY_KILLS          = { type = "int",   stat = "ASLTMG_ENEMY_KILLS"             },
    MPX_RPG_ENEMY_KILLS             = { type = "int",   stat = "RPG_ENEMY_KILLS"                },
    MPX_PISTOL_ENEMY_KILLS          = { type = "int",   stat = "PISTOL_ENEMY_KILLS"             },
    MPX_PLAYER_HEADSHOTS            = { type = "int",   stat = "PLAYER_HEADSHOTS"               },
    MPX_SAWNOFF_ENEMY_KILLS         = { type = "int",   stat = "SAWNOFF_ENEMY_KILLS"            },
    MPX_AWD_VEHICLES_JACKEDR        = { type = "int",   stat = "AWD_VEHICLES_JACKEDR"           },
    MPX_NUMBER_CRASHES_CARS         = { type = "int",   stat = "NUMBER_CRASHES_CARS"            },
    MPX_NUMBER_CRASHES_BIKES        = { type = "int",   stat = "NUMBER_CRASHES_BIKES"           },
    MPX_BAILED_FROM_VEHICLE         = { type = "int",   stat = "BAILED_FROM_VEHICLE"            },
    MPX_NUMBER_CRASHES_QUADBIKES    = { type = "int",   stat = "NUMBER_CRASHES_QUADBIKES"       },
    MPX_NUMBER_STOLEN_COP_VEHICLE   = { type = "int",   stat = "NUMBER_STOLEN_COP_VEHICLE"      },
    MPX_NUMBER_STOLEN_CARS          = { type = "int",   stat = "NUMBER_STOLEN_CARS"             },
    MPX_NUMBER_STOLEN_BIKES         = { type = "int",   stat = "NUMBER_STOLEN_BIKES"            },
    MPX_NUMBER_STOLEN_BOATS         = { type = "int",   stat = "NUMBER_STOLEN_BOATS"            },
    MPX_NUMBER_STOLEN_HELIS         = { type = "int",   stat = "NUMBER_STOLEN_HELIS"            },
    MPX_NUMBER_STOLEN_PLANES        = { type = "int",   stat = "NUMBER_STOLEN_PLANES"           },
    MPX_NUMBER_STOLEN_QUADBIKES     = { type = "int",   stat = "NUMBER_STOLEN_QUADBIKES"        },
    MPX_NUMBER_STOLEN_BICYCLES      = { type = "int",   stat = "NUMBER_STOLEN_BICYCLES"         },
    MPX_CARS_COPS_EXPLODED          = { type = "int",   stat = "CARS_COPS_EXPLODED"             },
    MPX_BOATS_EXPLODED              = { type = "int",   stat = "BOATS_EXPLODED"                 },
    MPX_PLANES_EXPLODED             = { type = "int",   stat = "PLANES_EXPLODED"                },
    MPX_AWD_FMTIME5STARWANTED       = { type = "int",   stat = "AWD_FMTIME5STARWANTED"          },
    MPX_AWD_ENEMYDRIVEBYKILLS       = { type = "int",   stat = "AWD_ENEMYDRIVEBYKILLS"          },
    MPX_BIKES_EXPLODED              = { type = "int",   stat = "BIKES_EXPLODED"                 },
    MPX_HITS_PEDS_VEHICLES          = { type = "int",   stat = "HITS_PEDS_VEHICLES"             },
    MPX_HEADSHOTS                   = { type = "int",   stat = "HEADSHOTS"                      },
    MPX_SUCCESSFUL_COUNTERS         = { type = "int",   stat = "SUCCESSFUL_COUNTERS"            },
    MPX_KILLS_STEALTH               = { type = "int",   stat = "KILLS_STEALTH"                  },
    MPX_KILLS_BY_OTHERS             = { type = "int",   stat = "KILLS_BY_OTHERS"                },
    MPX_TOTAL_NO_SHOPS_HELD_UP      = { type = "int",   stat = "TOTAL_NO_SHOPS_HELD_UP"         },
    MPX_HELIS_EXPLODED              = { type = "int",   stat = "HELIS_EXPLODED"                 },
    MPX_AWD_5STAR_WANTED_AVOIDANCE  = { type = "int",   stat = "AWD_5STAR_WANTED_AVOIDANCE"     },
    MPX_QUADBIKE_EXPLODED           = { type = "int",   stat = "QUADBIKE_EXPLODED"              },
    MPX_GRENADE_ENEMY_KILLS         = { type = "int",   stat = "GRENADE_ENEMY_KILLS"            },
    MPX_STKYBMB_ENEMY_KILLS         = { type = "int",   stat = "STKYBMB_ENEMY_KILLS"            },
    MPX_UNARMED_ENEMY_KILLS         = { type = "int",   stat = "UNARMED_ENEMY_KILLS"            },
    MPX_BICYCLE_EXPLODED            = { type = "int",   stat = "BICYCLE_EXPLODED"               },
    MPX_SUBMARINE_EXPLODED          = { type = "int",   stat = "SUBMARINE_EXPLODED"             },
    MPX_AWD_FMSHOOTDOWNCOPHELI      = { type = "int",   stat = "AWD_FMSHOOTDOWNCOPHELI"         },
    MPX_AWD_SECURITY_CARS_ROBBED    = { type = "int",   stat = "AWD_SECURITY_CARS_ROBBED"       },
    MPX_AWD_ODISTRACTCOPSNOEATH     = { type = "int",   stat = "AWD_ODISTRACTCOPSNOEATH"        },
    MPX_AWD_HOLD_UP_SHOPS           = { type = "int",   stat = "AWD_HOLD_UP_SHOPS"              },
    MPX_HORDELVL                    = { type = "int",   stat = "HORDELVL"                       },
    MPX_FAVOUTFITBIKETIMECURRENT    = { type = "int",   stat = "FAVOUTFITBIKETIMECURRENT"       },
    MPX_FAVOUTFITBIKETIME1ALLTIME   = { type = "int",   stat = "FAVOUTFITBIKETIME1ALLTIME"      },
    MPX_FAVOUTFITBIKETYPECURRENT    = { type = "int",   stat = "FAVOUTFITBIKETYPECURRENT"       },
    MPX_FAVOUTFITBIKETYPEALLTIME    = { type = "int",   stat = "FAVOUTFITBIKETYPEALLTIME"       },
    MPX_NO_CARS_REPAIR              = { type = "int",   stat = "NO_CARS_REPAIR"                 },
    MPX_LONGEST_WHEELIE_DIST        = { type = "int",   stat = "LONGEST_WHEELIE_DIST"           },
    MPX_AWD_50_VEHICLES_BLOWNUP     = { type = "int",   stat = "AWD_50_VEHICLES_BLOWNUP"        },
    MPX_CARS_EXPLODED               = { type = "int",   stat = "CARS_EXPLODED"                  },
    MPX_VEHICLES_SPRAYED            = { type = "int",   stat = "VEHICLES_SPRAYED"               },
    MPX_NUMBER_NEAR_MISS_NOCRASH    = { type = "int",   stat = "NUMBER_NEAR_MISS_NOCRASH"       },
    MPX_AWD_CAR_EXPORT              = { type = "int",   stat = "AWD_CAR_EXPORT"                 },
    MPX_RACES_WON                   = { type = "int",   stat = "RACES_WON"                      },
    MPX_USJS_FOUND                  = { type = "int",   stat = "USJS_FOUND"                     },
    MPX_USJS_COMPLETED              = { type = "int",   stat = "USJS_COMPLETED"                 },
    MPX_USJS_TOTAL_COMPLETED        = { type = "int",   stat = "USJS_TOTAL_COMPLETED"           },
    MPX_AWD_FMDRIVEWITHOUTCRASH     = { type = "int",   stat = "AWD_FMDRIVEWITHOUTCRASH"        },
    MPX_AWD_VEHICLE_JUMP_OVER_40M   = { type = "int",   stat = "AWD_VEHICLE_JUMP_OVER_40M"      },
    MPX_COUNT_HOTRING_RACE          = { type = "int",   stat = "COUNT_HOTRING_RACE"             },
    MPX_MOST_FLIPS_IN_ONE_JUMP      = { type = "int",   stat = "MOST_FLIPS_IN_ONE_JUMP"         },
    MPX_MOST_SPINS_IN_ONE_JUMP      = { type = "int",   stat = "MOST_SPINS_IN_ONE_JUMP"         },
    MPX_CRDEADLINE                  = { type = "int",   stat = "CRDEADLINE"                     },
    MPX_AWD_PASSENGERTIME           = { type = "int",   stat = "AWD_PASSENGERTIME"              },
    MPX_AWD_TIME_IN_HELICOPTER      = { type = "int",   stat = "AWD_TIME_IN_HELICOPTER"         },
    MPX_CHAR_FM_VEHICLE_1_UNLCK     = { type = "int",   stat = "CHAR_FM_VEHICLE_1_UNLCK"        },
    MPX_CHAR_FM_VEHICLE_2_UNLCK     = { type = "int",   stat = "CHAR_FM_VEHICLE_2_UNLCK"        },
    MPX_HITS                        = { type = "int",   stat = "HITS"                           },
    MPX_AWD_FMOVERALLKILLS          = { type = "int",   stat = "AWD_FMOVERALLKILLS"             },
    MPX_NUMBER_NEAR_MISS            = { type = "int",   stat = "NUMBER_NEAR_MISS"               },
    MPX_HIGHEST_SKITTLES            = { type = "int",   stat = "HIGHEST_SKITTLES"               },
    MPX_MELEEKILLS                  = { type = "int",   stat = "MELEEKILLS"                     },
    MPX_AWD_100_HEADSHOTS           = { type = "int",   stat = "AWD_100_HEADSHOTS"              },
    MPX_AWD_100_KILLS_PISTOL        = { type = "int",   stat = "AWD_100_KILLS_PISTOL"           },
    MPX_AWD_100_KILLS_SMG           = { type = "int",   stat = "AWD_100_KILLS_SMG"              },
    MPX_AWD_100_KILLS_SHOTGUN       = { type = "int",   stat = "AWD_100_KILLS_SHOTGUN"          },
    MPX_ASLTRIFLE_ENEMY_KILLS       = { type = "int",   stat = "ASLTRIFLE_ENEMY_KILLS"          },
    MPX_AWD_100_KILLS_SNIPER        = { type = "int",   stat = "AWD_100_KILLS_SNIPER"           },
    MPX_AWD_FM_DM_TOTALKILLS        = { type = "int",   stat = "AWD_FM_DM_TOTALKILLS"           },
    MPX_DEATHS                      = { type = "int",   stat = "DEATHS"                         },
    MPX_AWD_FM_DM_KILLSTREAK        = { type = "int",   stat = "AWD_FM_DM_KILLSTREAK"           },
    MPX_AWD_KILL_CARRIER_CAPTURE    = { type = "int",   stat = "AWD_KILL_CARRIER_CAPTURE"       },
    MPX_AWD_NIGHTVISION_KILLS       = { type = "int",   stat = "AWD_NIGHTVISION_KILLS"          },
    MPX_AWD_KILL_PSYCHOPATHS        = { type = "int",   stat = "AWD_KILL_PSYCHOPATHS"           },
    MPX_AWD_FMREVENGEKILLSDM        = { type = "int",   stat = "AWD_FMREVENGEKILLSDM"           },
    MPX_AWD_TAKEDOWNSMUGPLANE       = { type = "int",   stat = "AWD_TAKEDOWNSMUGPLANE"          },
    MPX_AWD_25_KILLS_STICKYBOMBS    = { type = "int",   stat = "AWD_25_KILLS_STICKYBOMBS"       },
    MPX_AWD_50_KILLS_GRENADES       = { type = "int",   stat = "AWD_50_KILLS_GRENADES"          },
    MPX_AWD_50_KILLS_ROCKETLAUNCH   = { type = "int",   stat = "AWD_50_KILLS_ROCKETLAUNCH"      },
    MPX_AWD_20_KILLS_MELEE          = { type = "int",   stat = "AWD_20_KILLS_MELEE"             },
    MPX_AWD_FM_DM_3KILLSAMEGUY      = { type = "int",   stat = "AWD_FM_DM_3KILLSAMEGUY"         },
    MPX_AWD_FM_DM_STOLENKILL        = { type = "int",   stat = "AWD_FM_DM_STOLENKILL"           },
    MPX_AWD_FMKILLBOUNTY            = { type = "int",   stat = "AWD_FMKILLBOUNTY"               },
    MPX_AWD_CAR_BOMBS_ENEMY_KILLS   = { type = "int",   stat = "AWD_CAR_BOMBS_ENEMY_KILLS"      },
    MPX_AWD_FINISH_HEISTS           = { type = "int",   stat = "AWD_FINISH_HEISTS"              },
    MPX_AWD_FINISH_HEIST_SETUP_JOB  = { type = "int",   stat = "AWD_FINISH_HEIST_SETUP_JOB"     },
    MPX_AWD_WIN_GOLD_MEDAL_HEISTS   = { type = "int",   stat = "AWD_WIN_GOLD_MEDAL_HEISTS"      },
    MPX_AWD_DO_HEIST_AS_MEMBER      = { type = "int",   stat = "AWD_DO_HEIST_AS_MEMBER"         },
    MPX_AWD_DO_HEIST_AS_THE_LEADER  = { type = "int",   stat = "AWD_DO_HEIST_AS_THE_LEADER"     },
    MPX_AWD_CONTROL_CROWDS          = { type = "int",   stat = "AWD_CONTROL_CROWDS"             },
    MPX_HEIST_COMPLETION            = { type = "int",   stat = "HEIST_COMPLETION"               },
    MPX_AWD_COMPLETE_HEIST_NOT_DIE  = { type = "int",   stat = "AWD_COMPLETE_HEIST_NOT_DIE"     },
    MPX_HEISTS_ORGANISED            = { type = "int",   stat = "HEISTS_ORGANISED"               },
    MPX_HEIST_START                 = { type = "int",   stat = "HEIST_START"                    },
    MPX_HEIST_END                   = { type = "int",   stat = "HEIST_END"                      },
    MPX_CUTSCENE_MID_PRISON         = { type = "int",   stat = "CUTSCENE_MID_PRISON"            },
    MPX_CUTSCENE_MID_HUMANE         = { type = "int",   stat = "CUTSCENE_MID_HUMANE"            },
    MPX_CUTSCENE_MID_NARC           = { type = "int",   stat = "CUTSCENE_MID_NARC"              },
    MPX_CUTSCENE_MID_ORNATE         = { type = "int",   stat = "CUTSCENE_MID_ORNATE"            },
    MPX_CR_FLEECA_PREP_1            = { type = "int",   stat = "CR_FLEECA_PREP_1"               },
    MPX_CR_FLEECA_PREP_2            = { type = "int",   stat = "CR_FLEECA_PREP_2"               },
    MPX_CR_FLEECA_FINALE            = { type = "int",   stat = "CR_FLEECA_FINALE"               },
    MPX_CR_PRISON_PLANE             = { type = "int",   stat = "CR_PRISON_PLANE"                },
    MPX_CR_PRISON_BUS               = { type = "int",   stat = "CR_PRISON_BUS"                  },
    MPX_CR_PRISON_STATION           = { type = "int",   stat = "CR_PRISON_STATION"              },
    MPX_CR_PRISON_UNFINISHED_BIZ    = { type = "int",   stat = "CR_PRISON_UNFINISHED_BIZ"       },
    MPX_CR_PRISON_FINALE            = { type = "int",   stat = "CR_PRISON_FINALE"               },
    MPX_CR_HUMANE_KEY_CODES         = { type = "int",   stat = "CR_HUMANE_KEY_CODES"            },
    MPX_CR_HUMANE_ARMORDILLOS       = { type = "int",   stat = "CR_HUMANE_ARMORDILLOS"          },
    MPX_CR_HUMANE_EMP               = { type = "int",   stat = "CR_HUMANE_EMP"                  },
    MPX_CR_HUMANE_VALKYRIE          = { type = "int",   stat = "CR_HUMANE_VALKYRIE"             },
    MPX_CR_HUMANE_FINALE            = { type = "int",   stat = "CR_HUMANE_FINALE"               },
    MPX_CR_NARC_COKE                = { type = "int",   stat = "CR_NARC_COKE"                   },
    MPX_CR_NARC_TRASH_TRUCK         = { type = "int",   stat = "CR_NARC_TRASH_TRUCK"            },
    MPX_CR_NARC_BIKERS              = { type = "int",   stat = "CR_NARC_BIKERS"                 },
    MPX_CR_NARC_WEED                = { type = "int",   stat = "CR_NARC_WEED"                   },
    MPX_CR_NARC_STEAL_METH          = { type = "int",   stat = "CR_NARC_STEAL_METH"             },
    MPX_CR_NARC_FINALE              = { type = "int",   stat = "CR_NARC_FINALE"                 },
    MPX_CR_PACIFIC_TRUCKS           = { type = "int",   stat = "CR_PACIFIC_TRUCKS"              },
    MPX_CR_PACIFIC_WITSEC           = { type = "int",   stat = "CR_PACIFIC_WITSEC"              },
    MPX_CR_PACIFIC_HACK             = { type = "int",   stat = "CR_PACIFIC_HACK"                },
    MPX_CR_PACIFIC_BIKES            = { type = "int",   stat = "CR_PACIFIC_BIKES"               },
    MPX_CR_PACIFIC_CONVOY           = { type = "int",   stat = "CR_PACIFIC_CONVOY"              },
    MPX_CR_PACIFIC_FINALE           = { type = "int",   stat = "CR_PACIFIC_FINALE"              },
    MPX_HEIST_PLANNING_STAGE        = { type = "int",   stat = "HEIST_PLANNING_STAGE"           },
    MPPLY_WIN_GOLD_MEDAL_HEISTS     = { type = "int",   stat = "MPPLY_WIN_GOLD_MEDAL_HEISTS"    },
    MPPLY_HEIST_ACH_TRACKER         = { type = "int",   stat = "MPPLY_HEIST_ACH_TRACKER"        },
    MPX_CR_GANGOP_MORGUE            = { type = "int",   stat = "CR_GANGOP_MORGUE"               },
    MPX_CR_GANGOP_DELUXO            = { type = "int",   stat = "CR_GANGOP_DELUXO"               },
    MPX_CR_GANGOP_SERVERFARM        = { type = "int",   stat = "CR_GANGOP_SERVERFARM"           },
    MPX_CR_GANGOP_IAABASE_FIN       = { type = "int",   stat = "CR_GANGOP_IAABASE_FIN"          },
    MPX_CR_GANGOP_STEALOSPREY       = { type = "int",   stat = "CR_GANGOP_STEALOSPREY"          },
    MPX_CR_GANGOP_FOUNDRY           = { type = "int",   stat = "CR_GANGOP_FOUNDRY"              },
    MPX_CR_GANGOP_RIOTVAN           = { type = "int",   stat = "CR_GANGOP_RIOTVAN"              },
    MPX_CR_GANGOP_SUBMARINECAR      = { type = "int",   stat = "CR_GANGOP_SUBMARINECAR"         },
    MPX_CR_GANGOP_SUBMARINE_FIN     = { type = "int",   stat = "CR_GANGOP_SUBMARINE_FIN"        },
    MPX_CR_GANGOP_PREDATOR          = { type = "int",   stat = "CR_GANGOP_PREDATOR"             },
    MPX_CR_GANGOP_BMLAUNCHER        = { type = "int",   stat = "CR_GANGOP_BMLAUNCHER"           },
    MPX_CR_GANGOP_BCCUSTOM          = { type = "int",   stat = "CR_GANGOP_BCCUSTOM"             },
    MPX_CR_GANGOP_STEALTHTANKS      = { type = "int",   stat = "CR_GANGOP_STEALTHTANKS"         },
    MPX_CR_GANGOP_SPYPLANE          = { type = "int",   stat = "CR_GANGOP_SPYPLANE"             },
    MPX_CR_GANGOP_FINALE            = { type = "int",   stat = "CR_GANGOP_FINALE"               },
    MPX_CR_GANGOP_FINALE_P2         = { type = "int",   stat = "CR_GANGOP_FINALE_P2"            },
    MPX_CR_GANGOP_FINALE_P3         = { type = "int",   stat = "CR_GANGOP_FINALE_P3"            },
    MPX_GANGOPS_FM_MISSION_PROG     = { type = "int",   stat = "GANGOPS_FM_MISSION_PROG"        },
    MPPLY_GANGOPS_ALLINORDER        = { type = "int",   stat = "MPPLY_GANGOPS_ALLINORDER"       },
    MPPLY_GANGOPS_LOYALTY           = { type = "int",   stat = "MPPLY_GANGOPS_LOYALTY"          },
    MPPLY_GANGOPS_CRIMMASMD         = { type = "int",   stat = "MPPLY_GANGOPS_CRIMMASMD"        },
    MPPLY_GANGOPS_LOYALTY2          = { type = "int",   stat = "MPPLY_GANGOPS_LOYALTY2"         },
    MPPLY_GANGOPS_LOYALTY3          = { type = "int",   stat = "MPPLY_GANGOPS_LOYALTY3"         },
    MPPLY_GANGOPS_CRIMMASMD2        = { type = "int",   stat = "MPPLY_GANGOPS_CRIMMASMD2"       },
    MPPLY_GANGOPS_CRIMMASMD3        = { type = "int",   stat = "MPPLY_GANGOPS_CRIMMASMD3"       },
    MPPLY_GANGOPS_SUPPORT           = { type = "int",   stat = "MPPLY_GANGOPS_SUPPORT"          },
    MPX_HUB_EARNINGS                = { type = "int",   stat = "HUB_EARNINGS"                   },
    MPX_NIGHTCLUB_EARNINGS          = { type = "int",   stat = "NIGHTCLUB_EARNINGS"             },
    MPX_NIGHTCLUB_HOTSPOT_TIME_MS   = { type = "int",   stat = "NIGHTCLUB_HOTSPOT_TIME_MS"      },
    MPX_DANCE_COMBO_DURATION_MINS   = { type = "int",   stat = "DANCE_COMBO_DURATION_MINS"      },
    MPX_LIFETIME_HUB_GOODS_SOLD     = { type = "int",   stat = "LIFETIME_HUB_GOODS_SOLD"        },
    MPX_LIFETIME_HUB_GOODS_MADE     = { type = "int",   stat = "LIFETIME_HUB_GOODS_MADE"        },
    MPX_HUB_SALES_COMPLETED         = { type = "int",   stat = "HUB_SALES_COMPLETED"            },
    MPX_CLUB_CONTRABAND_MISSION     = { type = "int",   stat = "CLUB_CONTRABAND_MISSION"        },
    MPX_HUB_CONTRABAND_MISSION      = { type = "int",   stat = "HUB_CONTRABAND_MISSION"         },
    MPX_NIGHTCLUB_VIP_APPEAR        = { type = "int",   stat = "NIGHTCLUB_VIP_APPEAR"           },
    MPX_NIGHTCLUB_JOBS_DONE         = { type = "int",   stat = "NIGHTCLUB_JOBS_DONE"            },
    MPX_AWD_CLUB_DRUNK              = { type = "int",   stat = "AWD_CLUB_DRUNK"                 },
    MPX_AWD_DANCE_TO_SOLOMUN        = { type = "int",   stat = "AWD_DANCE_TO_SOLOMUN"           },
    MPX_AWD_DANCE_TO_TALEOFUS       = { type = "int",   stat = "AWD_DANCE_TO_TALEOFUS"          },
    MPX_AWD_DANCE_TO_DIXON          = { type = "int",   stat = "AWD_DANCE_TO_DIXON"             },
    MPX_AWD_DANCE_TO_BLKMAD         = { type = "int",   stat = "AWD_DANCE_TO_BLKMAD"            },
    MPX_DANCEPERFECTOWNCLUB         = { type = "int",   stat = "DANCEPERFECTOWNCLUB"            },
    MPX_NUMUNIQUEPLYSINCLUB         = { type = "int",   stat = "NUMUNIQUEPLYSINCLUB"            },
    MPX_NIGHTCLUB_PLAYER_APPEAR     = { type = "int",   stat = "NIGHTCLUB_PLAYER_APPEAR"        },
    MPX_NIGHTCLUB_CONT_TOTAL        = { type = "int",   stat = "NIGHTCLUB_CONT_TOTAL"           },
    MPX_DANCETODIFFDJS              = { type = "int",   stat = "DANCETODIFFDJS"                 },
    MPX_NIGHTCLUB_CONT_MISSION      = { type = "int",   stat = "NIGHTCLUB_CONT_MISSION"         },
    MPX_ARN_SPEC_BOX_TIME_MS        = { type = "int",   stat = "ARN_SPEC_BOX_TIME_MS"           },
    MPX_ARENAWARS_AP_LIFETIME       = { type = "int",   stat = "ARENAWARS_AP_LIFETIME"          },
    MPX_AWD_ARENA_WAGEWORKER        = { type = "int",   stat = "AWD_ARENA_WAGEWORKER"           },
    MPX_ARN_VEH_ISSI                = { type = "int",   stat = "ARN_VEH_ISSI"                   },
    MPX_AWD_TOP_SCORE               = { type = "int",   stat = "AWD_TOP_SCORE"                  },
    MPX_ARN_SPECTATOR_DRONE         = { type = "int",   stat = "ARN_SPECTATOR_DRONE"            },
    MPX_ARN_SPECTATOR_CAMS          = { type = "int",   stat = "ARN_SPECTATOR_CAMS"             },
    MPX_ARN_SMOKE                   = { type = "int",   stat = "ARN_SMOKE"                      },
    MPX_ARN_DRINK                   = { type = "int",   stat = "ARN_DRINK"                      },
    MPX_ARN_VEH_MONSTER             = { type = "int",   stat = "ARN_VEH_MONSTER"                },
    MPX_ARN_VEH_CERBERUS            = { type = "int",   stat = "ARN_VEH_CERBERUS"               },
    MPX_ARN_VEH_CERBERUS2           = { type = "int",   stat = "ARN_VEH_CERBERUS2"              },
    MPX_ARN_VEH_CERBERUS3           = { type = "int",   stat = "ARN_VEH_CERBERUS3"              },
    MPX_ARN_VEH_BRUISER             = { type = "int",   stat = "ARN_VEH_BRUISER"                },
    MPX_ARN_VEH_BRUISER2            = { type = "int",   stat = "ARN_VEH_BRUISER2"               },
    MPX_ARN_VEH_BRUISER3            = { type = "int",   stat = "ARN_VEH_BRUISER3"               },
    MPX_ARN_VEH_SLAMVAN4            = { type = "int",   stat = "ARN_VEH_SLAMVAN4"               },
    MPX_ARN_VEH_SLAMVAN5            = { type = "int",   stat = "ARN_VEH_SLAMVAN5"               },
    MPX_ARN_VEH_SLAMVAN6            = { type = "int",   stat = "ARN_VEH_SLAMVAN6"               },
    MPX_ARN_VEH_BRUTUS              = { type = "int",   stat = "ARN_VEH_BRUTUS"                 },
    MPX_ARN_VEH_BRUTUS2             = { type = "int",   stat = "ARN_VEH_BRUTUS2"                },
    MPX_ARN_VEH_BRUTUS3             = { type = "int",   stat = "ARN_VEH_BRUTUS3"                },
    MPX_ARN_VEH_SCARAB              = { type = "int",   stat = "ARN_VEH_SCARAB"                 },
    MPX_ARN_VEH_SCARAB2             = { type = "int",   stat = "ARN_VEH_SCARAB2"                },
    MPX_ARN_VEH_SCARAB3             = { type = "int",   stat = "ARN_VEH_SCARAB3"                },
    MPX_ARN_VEH_DOMINATOR4          = { type = "int",   stat = "ARN_VEH_DOMINATOR4"             },
    MPX_ARN_VEH_DOMINATOR5          = { type = "int",   stat = "ARN_VEH_DOMINATOR5"             },
    MPX_ARN_VEH_DOMINATOR6          = { type = "int",   stat = "ARN_VEH_DOMINATOR6"             },
    MPX_ARN_VEH_IMPALER2            = { type = "int",   stat = "ARN_VEH_IMPALER2"               },
    MPX_ARN_VEH_IMPALER3            = { type = "int",   stat = "ARN_VEH_IMPALER3"               },
    MPX_ARN_VEH_IMPALER4            = { type = "int",   stat = "ARN_VEH_IMPALER4"               },
    MPX_ARN_VEH_ISSI4               = { type = "int",   stat = "ARN_VEH_ISSI4"                  },
    MPX_ARN_VEH_ISSI5               = { type = "int",   stat = "ARN_VEH_ISSI5"                  },
    MPX_AWD_TIME_SERVED             = { type = "int",   stat = "AWD_TIME_SERVED"                },
    MPX_AWD_CAREER_WINNER           = { type = "int",   stat = "AWD_CAREER_WINNER"              },
    MPX_ARENAWARS_AP_TIER           = { type = "int",   stat = "ARENAWARS_AP_TIER"              },
    MPX_ARN_W_THEME_SCIFI           = { type = "int",   stat = "ARN_W_THEME_SCIFI"              },
    MPX_ARN_W_THEME_APOC            = { type = "int",   stat = "ARN_W_THEME_APOC"               },
    MPX_ARN_W_THEME_CONS            = { type = "int",   stat = "ARN_W_THEME_CONS"               },
    MPX_ARN_W_PASS_THE_BOMB         = { type = "int",   stat = "ARN_W_PASS_THE_BOMB"            },
    MPX_ARN_W_DETONATION            = { type = "int",   stat = "ARN_W_DETONATION"               },
    MPX_ARN_W_ARCADE_RACE           = { type = "int",   stat = "ARN_W_ARCADE_RACE"              },
    MPX_ARN_W_CTF                   = { type = "int",   stat = "ARN_W_CTF"                      },
    MPX_ARN_W_TAG_TEAM              = { type = "int",   stat = "ARN_W_TAG_TEAM"                 },
    MPX_ARN_W_DESTR_DERBY           = { type = "int",   stat = "ARN_W_DESTR_DERBY"              },
    MPX_ARN_W_CARNAGE               = { type = "int",   stat = "ARN_W_CARNAGE"                  },
    MPX_ARN_W_MONSTER_JAM           = { type = "int",   stat = "ARN_W_MONSTER_JAM"              },
    MPX_ARN_W_GAMES_MASTERS         = { type = "int",   stat = "ARN_W_GAMES_MASTERS"            },
    MPX_ARENAWARS_CARRER_WINS       = { type = "int",   stat = "ARENAWARS_CARRER_WINS"          },
    MPX_ARENAWARS_CARRER_WINT       = { type = "int",   stat = "ARENAWARS_CARRER_WINT"          },
    MPX_ARENAWARS_MATCHES_PLYD      = { type = "int",   stat = "ARENAWARS_MATCHES_PLYD"         },
    MPX_ARENAWARS_MATCHES_PLYDT     = { type = "int",   stat = "ARENAWARS_MATCHES_PLYDT"        },
    MPX_ARN_VEH_IMPERATOR           = { type = "int",   stat = "ARN_VEH_IMPERATOR"              },
    MPX_ARN_VEH_IMPERATOR2          = { type = "int",   stat = "ARN_VEH_IMPERATOR2"             },
    MPX_ARN_VEH_IMPERATOR3          = { type = "int",   stat = "ARN_VEH_IMPERATOR3"             },
    MPX_ARN_VEH_ZR380               = { type = "int",   stat = "ARN_VEH_ZR380"                  },
    MPX_ARN_VEH_ZR3802              = { type = "int",   stat = "ARN_VEH_ZR3802"                 },
    MPX_ARN_VEH_ZR3803              = { type = "int",   stat = "ARN_VEH_ZR3803"                 },
    MPX_ARN_VEH_DEATHBIKE           = { type = "int",   stat = "ARN_VEH_DEATHBIKE"              },
    MPX_ARN_VEH_DEATHBIKE2          = { type = "int",   stat = "ARN_VEH_DEATHBIKE2"             },
    MPX_ARN_VEH_DEATHBIKE3          = { type = "int",   stat = "ARN_VEH_DEATHBIKE3"             },
    MPX_NUMBER_OF_CHAMP_BOUGHT      = { type = "int",   stat = "NUMBER_OF_CHAMP_BOUGHT"         },
    MPX_ARN_SPECTATOR_KILLS         = { type = "int",   stat = "ARN_SPECTATOR_KILLS"            },
    MPX_ARN_LIFETIME_KILLS          = { type = "int",   stat = "ARN_LIFETIME_KILLS"             },
    MPX_ARN_L_PASS_THE_BOMB         = { type = "int",   stat = "ARN_L_PASS_THE_BOMB"            },
    MPX_ARN_L_DETONATION            = { type = "int",   stat = "ARN_L_DETONATION"               },
    MPX_ARN_L_ARCADE_RACE           = { type = "int",   stat = "ARN_L_ARCADE_RACE"              },
    MPX_ARN_L_CTF                   = { type = "int",   stat = "ARN_L_CTF"                      },
    MPX_ARN_L_TAG_TEAM              = { type = "int",   stat = "ARN_L_TAG_TEAM"                 },
    MPX_ARN_L_DESTR_DERBY           = { type = "int",   stat = "ARN_L_DESTR_DERBY"              },
    MPX_ARN_L_CARNAGE               = { type = "int",   stat = "ARN_L_CARNAGE"                  },
    MPX_ARN_L_MONSTER_JAM           = { type = "int",   stat = "ARN_L_MONSTER_JAM"              },
    MPX_ARN_L_GAMES_MASTERS         = { type = "int",   stat = "ARN_L_GAMES_MASTERS"            },
    MPX_ARN_LIFETIME_DEATHS         = { type = "int",   stat = "ARN_LIFETIME_DEATHS"            },
    MPX_AWD_YOURE_OUTTA_HERE        = { type = "int",   stat = "AWD_YOURE_OUTTA_HERE"           },
    MPX_ARENAWARS_SP_LIFETIME       = { type = "int",   stat = "ARENAWARS_SP_LIFETIME"          },
    MPX_AWD_WATCH_YOUR_STEP         = { type = "int",   stat = "AWD_WATCH_YOUR_STEP"            },
    MPX_AWD_TOWER_OFFENSE           = { type = "int",   stat = "AWD_TOWER_OFFENSE"              },
    MPX_AWD_READY_FOR_WAR           = { type = "int",   stat = "AWD_READY_FOR_WAR"              },
    MPX_AWD_THROUGH_A_LENS          = { type = "int",   stat = "AWD_THROUGH_A_LENS"             },
    MPX_AWD_SPINNER                 = { type = "int",   stat = "AWD_SPINNER"                    },
    MPX_AWD_YOUMEANBOOBYTRAPS       = { type = "int",   stat = "AWD_YOUMEANBOOBYTRAPS"          },
    MPX_AWD_MASTER_BANDITO          = { type = "int",   stat = "AWD_MASTER_BANDITO"             },
    MPX_AWD_SITTING_DUCK            = { type = "int",   stat = "AWD_SITTING_DUCK"               },
    MPX_AWD_CROWDPARTICIPATION      = { type = "int",   stat = "AWD_CROWDPARTICIPATION"         },
    MPX_AWD_KILL_OR_BE_KILLED       = { type = "int",   stat = "AWD_KILL_OR_BE_KILLED"          },
    MPX_AWD_MASSIVE_SHUNT           = { type = "int",   stat = "AWD_MASSIVE_SHUNT"              },
    MPX_AWD_WEVE_GOT_ONE            = { type = "int",   stat = "AWD_WEVE_GOT_ONE"               },
    MPX_ARENAWARS_SKILL_LEVEL       = { type = "int",   stat = "ARENAWARS_SKILL_LEVEL"          },
    MPX_ARENAWARS_SP                = { type = "int",   stat = "ARENAWARS_SP"                   },
    MPX_ARENAWARS_AP                = { type = "int",   stat = "ARENAWARS_AP"                   },
    MPX_ARENAWARS_CARRER_UNLK       = { type = "int",   stat = "ARENAWARS_CARRER_UNLK"          },
    MPX_ARN_BS_TRINKET_TICKERS      = { type = "int",   stat = "ARN_BS_TRINKET_TICKERS"         },
    MPX_ARN_BS_TRINKET_SAVED        = { type = "int",   stat = "ARN_BS_TRINKET_SAVED"           },
    MPX_AWD_ODD_JOBS                = { type = "int",   stat = "AWD_ODD_JOBS"                   },
    MPX_VCM_STORY_PROGRESS          = { type = "int",   stat = "VCM_STORY_PROGRESS"             },
    MPX_VCM_FLOW_PROGRESS           = { type = "int",   stat = "VCM_FLOW_PROGRESS"              },
    MPX_AWD_ASTROCHIMP              = { type = "int",   stat = "AWD_ASTROCHIMP"                 },
    MPX_AWD_BATSWORD                = { type = "int",   stat = "AWD_BATSWORD"                   },
    MPX_AWD_COINPURSE               = { type = "int",   stat = "AWD_COINPURSE"                  },
    MPX_AWD_DAICASHCRAB             = { type = "int",   stat = "AWD_DAICASHCRAB"                },
    MPX_AWD_MASTERFUL               = { type = "int",   stat = "AWD_MASTERFUL"                  },
    MPX_H3_CR_STEALTH_1A            = { type = "int",   stat = "H3_CR_STEALTH_1A"               },
    MPX_H3_CR_STEALTH_2B_RAPP       = { type = "int",   stat = "H3_CR_STEALTH_2B_RAPP"          },
    MPX_H3_CR_STEALTH_2C_SIDE       = { type = "int",   stat = "H3_CR_STEALTH_2C_SIDE"          },
    MPX_H3_CR_STEALTH_3A            = { type = "int",   stat = "H3_CR_STEALTH_3A"               },
    MPX_H3_CR_STEALTH_4A            = { type = "int",   stat = "H3_CR_STEALTH_4A"               },
    MPX_H3_CR_STEALTH_5A            = { type = "int",   stat = "H3_CR_STEALTH_5A"               },
    MPX_H3_CR_SUBTERFUGE_1A         = { type = "int",   stat = "H3_CR_SUBTERFUGE_1A"            },
    MPX_H3_CR_SUBTERFUGE_2A         = { type = "int",   stat = "H3_CR_SUBTERFUGE_2A"            },
    MPX_H3_CR_SUBTERFUGE_2B         = { type = "int",   stat = "H3_CR_SUBTERFUGE_2B"            },
    MPX_H3_CR_SUBTERFUGE_3A         = { type = "int",   stat = "H3_CR_SUBTERFUGE_3A"            },
    MPX_H3_CR_SUBTERFUGE_3B         = { type = "int",   stat = "H3_CR_SUBTERFUGE_3B"            },
    MPX_H3_CR_SUBTERFUGE_4A         = { type = "int",   stat = "H3_CR_SUBTERFUGE_4A"            },
    MPX_H3_CR_SUBTERFUGE_5A         = { type = "int",   stat = "H3_CR_SUBTERFUGE_5A"            },
    MPX_H3_CR_DIRECT_1A             = { type = "int",   stat = "H3_CR_DIRECT_1A"                },
    MPX_H3_CR_DIRECT_2A1            = { type = "int",   stat = "H3_CR_DIRECT_2A1"               },
    MPX_H3_CR_DIRECT_2A2            = { type = "int",   stat = "H3_CR_DIRECT_2A2"               },
    MPX_H3_CR_DIRECT_2BP            = { type = "int",   stat = "H3_CR_DIRECT_2BP"               },
    MPX_H3_CR_DIRECT_2C             = { type = "int",   stat = "H3_CR_DIRECT_2C"                },
    MPX_H3_CR_DIRECT_3A             = { type = "int",   stat = "H3_CR_DIRECT_3A"                },
    MPX_H3_CR_DIRECT_4A             = { type = "int",   stat = "H3_CR_DIRECT_4A"                },
    MPX_H3_CR_DIRECT_5A             = { type = "int",   stat = "H3_CR_DIRECT_5A"                },
    MPX_CR_ORDER                    = { type = "int",   stat = "CR_ORDER"                       },
    MPX_SIGNAL_JAMMERS_COLLECTED    = { type = "int",   stat = "SIGNAL_JAMMERS_COLLECTED"       },
    MPX_AWD_PREPARATION             = { type = "int",   stat = "AWD_PREPARATION"                },
    MPX_AWD_BIGBRO                  = { type = "int",   stat = "AWD_BIGBRO"                     },
    MPX_AWD_SHARPSHOOTER            = { type = "int",   stat = "AWD_SHARPSHOOTER"               },
    MPX_AWD_RACECHAMP               = { type = "int",   stat = "AWD_RACECHAMP"                  },
    MPX_AWD_ASLEEPONJOB             = { type = "int",   stat = "AWD_ASLEEPONJOB"                },
    MPX_CAS_HEIST_NOTS              = { type = "int",   stat = "CAS_HEIST_NOTS"                 },
    MPX_CAS_HEIST_FLOW              = { type = "int",   stat = "CAS_HEIST_FLOW"                 },
    MPX_H3_BOARD_DIALOGUE0          = { type = "int",   stat = "H3_BOARD_DIALOGUE0"             },
    MPX_H3_BOARD_DIALOGUE1          = { type = "int",   stat = "H3_BOARD_DIALOGUE1"             },
    MPX_H3_BOARD_DIALOGUE2          = { type = "int",   stat = "H3_BOARD_DIALOGUE2"             },
    MPX_H3_VEHICLESUSED             = { type = "int",   stat = "H3_VEHICLESUSED"                },
    MPX_IAP_MAX_MOON_DIST           = { type = "int",   stat = "IAP_MAX_MOON_DIST"              },
    MPX_SCGW_NUM_WINS_GANG_0        = { type = "int",   stat = "SCGW_NUM_WINS_GANG_0"           },
    MPX_SCGW_NUM_WINS_GANG_1        = { type = "int",   stat = "SCGW_NUM_WINS_GANG_1"           },
    MPX_SCGW_NUM_WINS_GANG_2        = { type = "int",   stat = "SCGW_NUM_WINS_GANG_2"           },
    MPX_SCGW_NUM_WINS_GANG_3        = { type = "int",   stat = "SCGW_NUM_WINS_GANG_3"           },
    MPX_CH_ARC_CAB_CLAW_TROPHY      = { type = "int",   stat = "CH_ARC_CAB_CLAW_TROPHY"         },
    MPX_CH_ARC_CAB_LOVE_TROPHY      = { type = "int",   stat = "CH_ARC_CAB_LOVE_TROPHY"         },
    MPX_AWD_FILL_YOUR_BAGS          = { type = "int",   stat = "AWD_FILL_YOUR_BAGS"             },
    MPX_AWD_SUNSET                  = { type = "int",   stat = "AWD_SUNSET"                     },
    MPX_AWD_KEINEMUSIK              = { type = "int",   stat = "AWD_KEINEMUSIK"                 },
    MPX_AWD_PALMS_TRAX              = { type = "int",   stat = "AWD_PALMS_TRAX"                 },
    MPX_AWD_MOODYMANN               = { type = "int",   stat = "AWD_MOODYMANN"                  },
    MPX_AWD_TREASURE_HUNTER         = { type = "int",   stat = "AWD_TREASURE_HUNTER"            },
    MPX_AWD_WRECK_DIVING            = { type = "int",   stat = "AWD_WRECK_DIVING"               },
    MPX_AWD_LOSTANDFOUND            = { type = "int",   stat = "AWD_LOSTANDFOUND"               },
    MPX_H4_PLAYTHROUGH_STATUS       = { type = "int",   stat = "H4_PLAYTHROUGH_STATUS"          },
    MPX_AWD_WELL_PREPARED           = { type = "int",   stat = "AWD_WELL_PREPARED"              },
    MPX_H4_H4_DJ_MISSIONS           = { type = "int",   stat = "H4_H4_DJ_MISSIONS"              },
    MPX_H4CNF_APPROACH              = { type = "int",   stat = "H4CNF_APPROACH"                 },
    MPX_H4_MISSIONS                 = { type = "int",   stat = "H4_MISSIONS"                    },
    MPX_AWD_TEST_CAR                = { type = "int",   stat = "AWD_TEST_CAR"                   },
    MPX_AWD_CAR_CLUB_MEM            = { type = "int",   stat = "AWD_CAR_CLUB_MEM"               },
    MPX_AWD_ROBBERY_CONTRACT        = { type = "int",   stat = "AWD_ROBBERY_CONTRACT"           },
    MPX_AWD_FACES_OF_DEATH          = { type = "int",   stat = "AWD_FACES_OF_DEATH"             },
    MPX_AWD_SPRINTRACER             = { type = "int",   stat = "AWD_SPRINTRACER"                },
    MPX_AWD_STREETRACER             = { type = "int",   stat = "AWD_STREETRACER"                },
    MPX_AWD_PURSUITRACER            = { type = "int",   stat = "AWD_PURSUITRACER"               },
    MPX_AWD_AUTO_SHOP               = { type = "int",   stat = "AWD_AUTO_SHOP"                  },
    MPX_AWD_GROUNDWORK              = { type = "int",   stat = "AWD_GROUNDWORK"                 },
    MPX_FIXER_EARNINGS              = { type = "int",   stat = "FIXER_EARNINGS"                 },
    MPX_FIXER_COUNT                 = { type = "int",   stat = "FIXER_COUNT"                    },
    MPX_FIXER_SC_VEH_RECOVERED      = { type = "int",   stat = "FIXER_SC_VEH_RECOVERED"         },
    MPX_FIXER_SC_VAL_RECOVERED      = { type = "int",   stat = "FIXER_SC_VAL_RECOVERED"         },
    MPX_FIXER_SC_GANG_TERMINATED    = { type = "int",   stat = "FIXER_SC_GANG_TERMINATED"       },
    MPX_FIXER_SC_VIP_RESCUED        = { type = "int",   stat = "FIXER_SC_VIP_RESCUED"           },
    MPX_FIXER_SC_ASSETS_PROTECTED   = { type = "int",   stat = "FIXER_SC_ASSETS_PROTECTED"      },
    MPX_FIXER_SC_EQ_DESTROYED       = { type = "int",   stat = "FIXER_SC_EQ_DESTROYED"          },
    MPX_AWD_PRODUCER                = { type = "int",   stat = "AWD_PRODUCER"                   },
    MPX_AWD_CONTRACTOR              = { type = "int",   stat = "AWD_CONTRACTOR"                 },
    MPX_AWD_COLD_CALLER             = { type = "int",   stat = "AWD_COLD_CALLER"                },
    MPX_FIXERTELEPHONEHITSCOMPL     = { type = "int",   stat = "FIXERTELEPHONEHITSCOMPL"        },
    MPX_PAYPHONE_BONUS_KILL_METHOD  = { type = "int",   stat = "PAYPHONE_BONUS_KILL_METHOD"     },
    MPX_FIXER_GENERAL_BS            = { type = "int",   stat = "FIXER_GENERAL_BS"               },
    MPX_FIXER_COMPLETED_BS          = { type = "int",   stat = "FIXER_COMPLETED_BS"             },
    MPX_FIXER_STORY_BS              = { type = "int",   stat = "FIXER_STORY_BS"                 },
    MPX_FIXER_STORY_STRAND          = { type = "int",   stat = "FIXER_STORY_STRAND"             },
    MPX_FIXER_STORY_COOLDOWN        = { type = "int",   stat = "FIXER_STORY_COOLDOWN"           },
    MPX_AWD_CALLME                  = { type = "int",   stat = "AWD_CALLME"                     },
    MPX_AWD_CHEMCOMPOUNDS           = { type = "int",   stat = "AWD_CHEMCOMPOUNDS"              },
    MPX_AWD_RUNRABBITRUN            = { type = "int",   stat = "AWD_RUNRABBITRUN"               },
    MPX_AWD_CAR_DEALER              = { type = "int",   stat = "AWD_CAR_DEALER"                 },
    MPX_AWD_SECOND_HAND_PARTS       = { type = "int",   stat = "AWD_SECOND_HAND_PARTS"          },
    MPX_AWD_PREP_WORK               = { type = "int",   stat = "AWD_PREP_WORK"                  },
    MPX_AWD_VEHICLE_ROBBERIES       = { type = "int",   stat = "AWD_VEHICLE_ROBBERIES"          },
    MPX_AWD_TOW_TRUCK_SERVICE       = { type = "int",   stat = "AWD_TOW_TRUCK_SERVICE"          },
    MPX_H4CNF_UNIFORM               = { type = "int",   stat = "H4CNF_UNIFORM"                  },
    MPX_H4CNF_GRAPPEL               = { type = "int",   stat = "H4CNF_GRAPPEL"                  },
    MPX_H4CNF_TROJAN                = { type = "int",   stat = "H4CNF_TROJAN"                   },
    MPX_H4CNF_WEP_DISRP             = { type = "int",   stat = "H4CNF_WEP_DISRP"                },
    MPX_H4CNF_ARM_DISRP             = { type = "int",   stat = "H4CNF_ARM_DISRP"                },
    MPX_H4CNF_HEL_DISRP             = { type = "int",   stat = "H4CNF_HEL_DISRP"                },
    MPX_H3OPT_DISRUPTSHIP           = { type = "int",   stat = "H3OPT_DISRUPTSHIP"              },
    MPX_H3OPT_KEYLEVELS             = { type = "int",   stat = "H3OPT_KEYLEVELS"                },
    MPX_H3OPT_BODYARMORLVL          = { type = "int",   stat = "H3OPT_BODYARMORLVL"             },
    MPX_H3OPT_BITSET0               = { type = "int",   stat = "H3OPT_BITSET0"                  },
    MPX_H3OPT_BITSET1               = { type = "int",   stat = "H3OPT_BITSET1"                  },
    MPX_H3_BOARD_DIALOGUE0          = { type = "int",   stat = "H3_BOARD_DIALOGUE0"             },
    MPX_H3_BOARD_DIALOGUE1          = { type = "int",   stat = "H3_BOARD_DIALOGUE1"             },
    MPX_H3_BOARD_DIALOGUE2          = { type = "int",   stat = "H3_BOARD_DIALOGUE2"             },
    MPX_H3OPT_COMPLETEDPOSIX        = { type = "int",   stat = "H3OPT_COMPLETEDPOSIX"           },
    MPX_HANGAR_CONTRABAND_TOTAL     = { type = "int",   stat = "HANGAR_CONTRABAND_TOTAL"        },
    MPX_SALV23_GEN_BS               = { type = "int",   stat = "SALV23_GEN_BS"                  },
    MPX_SALV23_SCOPE_BS             = { type = "int",   stat = "SALV23_SCOPE_BS"                },
    MPX_SALV23_FM_PROG              = { type = "int",   stat = "SALV23_FM_PROG"                 },
    MPX_SALV23_INST_PROG            = { type = "int",   stat = "SALV23_INST_PROG"               },
    MPX_TUNER_CURRENT               = { type = "int",   stat = "TUNER_CURRENT"                  },
    MPX_TUNER_GEN_BS                = { type = "int",   stat = "TUNER_GEN_BS"                   },
    MPX_TUNER_CONTRACT0_POSIX       = { type = "int",   stat = "TUNER_CONTRACT0_POSIX"          },
    MPX_TUNER_CONTRACT1_POSIX       = { type = "int",   stat = "TUNER_CONTRACT1_POSIX"          },
    MPX_TUNER_CONTRACT2_POSIX       = { type = "int",   stat = "TUNER_CONTRACT2_POSIX"          },
    MPX_TUNER_CONTRACT3_POSIX       = { type = "int",   stat = "TUNER_CONTRACT3_POSIX"          },
    MPX_TUNER_CONTRACT4_POSIX       = { type = "int",   stat = "TUNER_CONTRACT4_POSIX"          },
    MPX_TUNER_CONTRACT5_POSIX       = { type = "int",   stat = "TUNER_CONTRACT5_POSIX"          },
    MPX_TUNER_CONTRACT6_POSIX       = { type = "int",   stat = "TUNER_CONTRACT6_POSIX"          },
    MPX_TUNER_CONTRACT7_POSIX       = { type = "int",   stat = "TUNER_CONTRACT7_POSIX"          },
    MPX_HEIST_SAVED_STRAND_0        = { type = "int",   stat = "HEIST_SAVED_STRAND_0"           },
    MPX_HEIST_SAVED_STRAND_0_L      = { type = "int",   stat = "HEIST_SAVED_STRAND_0_L"         },
    MPX_HEIST_SAVED_STRAND_1        = { type = "int",   stat = "HEIST_SAVED_STRAND_1"           },
    MPX_HEIST_SAVED_STRAND_1_L      = { type = "int",   stat = "HEIST_SAVED_STRAND_1_L"         },
    MPX_HEIST_SAVED_STRAND_2        = { type = "int",   stat = "HEIST_SAVED_STRAND_2"           },
    MPX_HEIST_SAVED_STRAND_2_L      = { type = "int",   stat = "HEIST_SAVED_STRAND_2_L"         },
    MPX_HEIST_SAVED_STRAND_3        = { type = "int",   stat = "HEIST_SAVED_STRAND_3"           },
    MPX_HEIST_SAVED_STRAND_3_L      = { type = "int",   stat = "HEIST_SAVED_STRAND_3_L"         },
    MPX_HEIST_SAVED_STRAND_4        = { type = "int",   stat = "HEIST_SAVED_STRAND_4"           },
    MPX_HEIST_SAVED_STRAND_4_L      = { type = "int",   stat = "HEIST_SAVED_STRAND_4_L"         },
    MPX_H4CNF_TARGET                = { type = "int",   stat = "H4CNF_TARGET"                   },
    MPX_H4CNF_WEAPONS               = { type = "int",   stat = "H4CNF_WEAPONS"                  },
    MPX_H4LOOT_CASH_C               = { type = "int",   stat = "H4LOOT_CASH_C"                  },
    MPX_H4LOOT_WEED_C               = { type = "int",   stat = "H4LOOT_WEED_C"                  },
    MPX_H4LOOT_COKE_C               = { type = "int",   stat = "H4LOOT_COKE_C"                  },
    MPX_H4LOOT_GOLD_C               = { type = "int",   stat = "H4LOOT_GOLD_C"                  },
    MPX_H4LOOT_CASH_I               = { type = "int",   stat = "H4LOOT_CASH_I"                  },
    MPX_H4LOOT_WEED_I               = { type = "int",   stat = "H4LOOT_WEED_I"                  },
    MPX_H4LOOT_COKE_I               = { type = "int",   stat = "H4LOOT_COKE_I"                  },
    MPX_H4LOOT_GOLD_I               = { type = "int",   stat = "H4LOOT_GOLD_I"                  },
    MPX_H4LOOT_CASH_C_SCOPED        = { type = "int",   stat = "H4LOOT_CASH_C_SCOPED"           },
    MPX_H4LOOT_WEED_C_SCOPED        = { type = "int",   stat = "H4LOOT_WEED_C_SCOPED"           },
    MPX_H4LOOT_COKE_C_SCOPED        = { type = "int",   stat = "H4LOOT_COKE_C_SCOPED"           },
    MPX_H4LOOT_GOLD_C_SCOPED        = { type = "int",   stat = "H4LOOT_GOLD_C_SCOPED"           },
    MPX_H4LOOT_CASH_I_SCOPED        = { type = "int",   stat = "H4LOOT_CASH_I_SCOPED"           },
    MPX_H4LOOT_WEED_I_SCOPED        = { type = "int",   stat = "H4LOOT_WEED_I_SCOPED"           },
    MPX_H4LOOT_COKE_I_SCOPED        = { type = "int",   stat = "H4LOOT_COKE_I_SCOPED"           },
    MPX_H4LOOT_GOLD_I_SCOPED        = { type = "int",   stat = "H4LOOT_GOLD_I_SCOPED"           },
    MPX_H4_PROGRESS                 = { type = "int",   stat = "H4_PROGRESS"                    },
    MPX_H4LOOT_CASH_V               = { type = "int",   stat = "H4LOOT_CASH_V"                  },
    MPX_H4LOOT_WEED_V               = { type = "int",   stat = "H4LOOT_WEED_V"                  },
    MPX_H4LOOT_COKE_V               = { type = "int",   stat = "H4LOOT_COKE_V"                  },
    MPX_H4LOOT_GOLD_V               = { type = "int",   stat = "H4LOOT_GOLD_V"                  },
    MPX_H4_TARGET_POSIX             = { type = "int",   stat = "H4_TARGET_POSIX"                },
    MPX_H4_COOLDOWN                 = { type = "int",   stat = "H4_COOLDOWN"                    },
    MPX_H4_COOLDOWN_HARD            = { type = "int",   stat = "H4_COOLDOWN_HARD"               },
    MPX_H4CNF_BS_GEN                = { type = "int",   stat = "H4CNF_BS_GEN"                   },
    MPX_H4CNF_BS_ENTR               = { type = "int",   stat = "H4CNF_BS_ENTR"                  },
    MPX_H4CNF_BS_ABIL               = { type = "int",   stat = "H4CNF_BS_ABIL"                  },
    MPX_H3OPT_TARGET                = { type = "int",   stat = "H3OPT_TARGET"                   },
    MPX_H3OPT_MASKS                 = { type = "int",   stat = "H3OPT_MASKS"                    },
    MPX_H3OPT_CREWWEAP              = { type = "int",   stat = "H3OPT_CREWWEAP"                 },
    MPX_H3OPT_WEAPS                 = { type = "int",   stat = "H3OPT_WEAPS"                    },
    MPX_H3OPT_CREWDRIVER            = { type = "int",   stat = "H3OPT_CREWDRIVER"               },
    MPX_H3OPT_VEHS                  = { type = "int",   stat = "H3OPT_VEHS"                     },
    MPX_H3OPT_CREWHACKER            = { type = "int",   stat = "H3OPT_CREWHACKER"               },
    MPX_H3_COMPLETEDPOSIX           = { type = "int",   stat = "H3_COMPLETEDPOSIX"              },
    MPPLY_H3_COOLDOWN               = { type = "int",   stat = "MPPLY_H3_COOLDOWN"              },
    MPX_H3OPT_POI                   = { type = "int",   stat = "H3OPT_POI"                      },
    MPX_H3OPT_ACCESSPOINTS          = { type = "int",   stat = "H3OPT_ACCESSPOINTS"             },
    MPX_SALV23_WEEK_SYNC            = { type = "int",   stat = "SALV23_WEEK_SYNC"               },
    MPX_SALV23_VEHROB_STATUS0       = { type = "int",   stat = "SALV23_VEHROB_STATUS0"          },
    MPX_SALV23_VEHROB_STATUS1       = { type = "int",   stat = "SALV23_VEHROB_STATUS1"          },
    MPX_SALV23_VEHROB_STATUS2       = { type = "int",   stat = "SALV23_VEHROB_STATUS2"          },
    MPX_LIFETIME_BKR_SEL_COMPLETBC5 = { type = "int",   stat = "LIFETIME_BKR_SEL_COMPLETBC5"    },
    MPX_LIFETIME_BKR_SEL_UNDERTABC5 = { type = "int",   stat = "LIFETIME_BKR_SEL_UNDERTABC5"    },
    MPX_BUNKER_UNITS_MANUFAC        = { type = "int",   stat = "BUNKER_UNITS_MANUFAC"           },
    MPX_LIFETIME_BKR_SELL_EARNINGS5 = { type = "int",   stat = "LIFETIME_BKR_SELL_EARNINGS5"    },
    MPPLY_CASINO_CHIPS_WON_GD       = { type = "int",   stat = "MPPLY_CASINO_CHIPS_WON_GD"      },
    MPPLY_CASINO_CHIPS_WONTIM       = { type = "int",   stat = "MPPLY_CASINO_CHIPS_WONTIM"      },
    MPPLY_CASINO_GMBLNG_GD          = { type = "int",   stat = "MPPLY_CASINO_GMBLNG_GD"         },
    MPPLY_CASINO_BAN_TIME           = { type = "int",   stat = "MPPLY_CASINO_BAN_TIME"          },
    MPPLY_CASINO_CHIPS_PURTIM       = { type = "int",   stat = "MPPLY_CASINO_CHIPS_PURTIM"      },
    MPPLY_CASINO_CHIPS_PUR_GD       = { type = "int",   stat = "MPPLY_CASINO_CHIPS_PUR_GD"      },
    MPX_LFETIME_HANGAR_BUY_COMPLET  = { type = "int",   stat = "LFETIME_HANGAR_BUY_COMPLET"     },
    MPX_LFETIME_HANGAR_BUY_UNDETAK  = { type = "int",   stat = "LFETIME_HANGAR_BUY_UNDETAK"     },
    MPX_LFETIME_HANGAR_SEL_COMPLET  = { type = "int",   stat = "LFETIME_HANGAR_SEL_COMPLET"     },
    MPX_LFETIME_HANGAR_SEL_UNDETAK  = { type = "int",   stat = "LFETIME_HANGAR_SEL_UNDETAK"     },
    MPX_LFETIME_HANGAR_EARNINGS     = { type = "int",   stat = "LFETIME_HANGAR_EARNINGS"        },
    MPPLY_TOTAL_EVC                 = { type = "int",   stat = "MPPLY_TOTAL_EVC"                },
    MPPLY_TOTAL_SVC                 = { type = "int",   stat = "MPPLY_TOTAL_SVC"                },
    MPX_MONEY_EARN_JOBS             = { type = "int",   stat = "MONEY_EARN_JOBS"                },
    MPX_MONEY_EARN_SELLING_VEH      = { type = "int",   stat = "MONEY_EARN_SELLING_VEH"         },
    MPX_MONEY_EARN_BETTING          = { type = "int",   stat = "MONEY_EARN_BETTING"             },
    MPX_MONEY_EARN_GOOD_SPORT       = { type = "int",   stat = "MONEY_EARN_GOOD_SPORT"          },
    MPX_MONEY_EARN_PICKED_UP        = { type = "int",   stat = "MONEY_EARN_PICKED_UP"           },
    MPX_MONEY_SPENT_WEAPON_ARMOR    = { type = "int",   stat = "MONEY_SPENT_WEAPON_ARMOR"       },
    MPX_MONEY_SPENT_VEH_MAINTENANCE = { type = "int",   stat = "MONEY_SPENT_VEH_MAINTENANCE"    },
    MPX_MONEY_SPENT_STYLE_ENT       = { type = "int",   stat = "MONEY_SPENT_STYLE_ENT"          },
    MPX_MONEY_SPENT_PROPERTY_UTIL   = { type = "int",   stat = "MONEY_SPENT_PROPERTY_UTIL"      },
    MPX_MONEY_SPENT_JOB_ACTIVITY    = { type = "int",   stat = "MONEY_SPENT_JOB_ACTIVITY"       },
    MPX_MONEY_SPENT_BETTING         = { type = "int",   stat = "MONEY_SPENT_BETTING"            },
    MPX_MONEY_SPENT_CONTACT_SERVICE = { type = "int",   stat = "MONEY_SPENT_CONTACT_SERVICE"    },
    MPX_MONEY_SPENT_HEALTHCARE      = { type = "int",   stat = "MONEY_SPENT_HEALTHCARE"         },
    MPX_MONEY_SPENT_DROPPED_STOLEN  = { type = "int",   stat = "MONEY_SPENT_DROPPED_STOLEN"     },
    MPX_CLUB_POPULARITY             = { type = "int",   stat = "CLUB_POPULARITY"                },
    MPX_CLUB_SAFE_CASH_VALUE        = { type = "int",   stat = "CLUB_SAFE_CASH_VALUE"           },
    MPX_HUB_PROD_TOTAL_0            = { type = "int",   stat = "HUB_PROD_TOTAL_0"               },
    MPX_HUB_PROD_TOTAL_1            = { type = "int",   stat = "HUB_PROD_TOTAL_1"               },
    MPX_HUB_PROD_TOTAL_2            = { type = "int",   stat = "HUB_PROD_TOTAL_2"               },
    MPX_HUB_PROD_TOTAL_3            = { type = "int",   stat = "HUB_PROD_TOTAL_3"               },
    MPX_HUB_PROD_TOTAL_4            = { type = "int",   stat = "HUB_PROD_TOTAL_4"               },
    MPX_HUB_PROD_TOTAL_5            = { type = "int",   stat = "HUB_PROD_TOTAL_5"               },
    MPX_HUB_PROD_TOTAL_6            = { type = "int",   stat = "HUB_PROD_TOTAL_6"               },
    MPX_LIFETIME_BUY_COMPLETE       = { type = "int",   stat = "LIFETIME_BUY_COMPLETE"          },
    MPX_LIFETIME_BUY_UNDERTAKEN     = { type = "int",   stat = "LIFETIME_BUY_UNDERTAKEN"        },
    MPX_LIFETIME_SELL_COMPLETE      = { type = "int",   stat = "LIFETIME_SELL_COMPLETE"         },
    MPX_LIFETIME_SELL_UNDERTAKEN    = { type = "int",   stat = "LIFETIME_SELL_UNDERTAKEN"       },
    MPX_LIFETIME_CONTRA_EARNINGS    = { type = "int",   stat = "LIFETIME_CONTRA_EARNINGS"       },
    MPX_PRODTOTALFORFACTORY5        = { type = "int",   stat = "PRODTOTALFORFACTORY5"           },
    MPPLY_CURRENT_CREW_RANK         = { type = "int",   stat = "MPPLY_CURRENT_CREW_RANK"        },
    MPX_CHAR_RANK_FM                = { type = "int",   stat = "CHAR_RANK_FM"                   },
    MPX_CHAR_SET_RP_GIFT_ADMIN      = { type = "int",   stat = "CHAR_SET_RP_GIFT_ADMIN"         },
    MPPLY_GLOBALXP                  = { type = "int",   stat = "MPPLY_GLOBALXP"                 },
    MPX_SR_HIGHSCORE_1              = { type = "int",   stat = "SR_HIGHSCORE_1"                 },
    MPX_SR_HIGHSCORE_2              = { type = "int",   stat = "SR_HIGHSCORE_2"                 },
    MPX_SR_HIGHSCORE_3              = { type = "int",   stat = "SR_HIGHSCORE_3"                 },
    MPX_SR_HIGHSCORE_4              = { type = "int",   stat = "SR_HIGHSCORE_4"                 },
    MPX_SR_HIGHSCORE_5              = { type = "int",   stat = "SR_HIGHSCORE_5"                 },
    MPX_SR_HIGHSCORE_6              = { type = "int",   stat = "SR_HIGHSCORE_6"                 },
    MPX_SR_TARGETS_HIT              = { type = "int",   stat = "SR_TARGETS_HIT"                 },
    MPX_SR_WEAPON_BIT_SET           = { type = "int",   stat = "SR_WEAPON_BIT_SET"              },
    MPX_TOTAL_RACES_WON             = { type = "int",   stat = "TOTAL_RACES_WON"                },
    MPX_AWD_TAXIDRIVER              = { type = "int",   stat = "AWD_TAXIDRIVER"                 },
    MPPLY_XMAS23_PLATES0            = { type = "int",   stat = "MPPLY_XMAS23_PLATES0"           },
    MPX_TATTOO_FM_CURRENT_32        = { type = "int",   stat = "TATTOO_FM_CURRENT_32"           },
    MPPLY_NUM_CAPTURES_CREATED      = { type = "int",   stat = "MPPLY_NUM_CAPTURES_CREATED"     },
    MPX_MOST_TIME_ON_3_PLUS_STARS   = { type = "int",   stat = "MOST_TIME_ON_3_PLUS_STARS"      },
    MPPLY_HEISTFLOWORDERPROGRESS    = { type = "int",   stat = "MPPLY_HEISTFLOWORDERPROGRESS"   },
    MPPLY_HEISTTEAMPROGRESSBITSET   = { type = "int",   stat = "MPPLY_HEISTTEAMPROGRESSBITSET"  },
    MPPLY_HEISTNODEATHPROGREITSET   = { type = "int",   stat = "MPPLY_HEISTNODEATHPROGREITSET"  },
    MPX_FACTORYSLOT0                = { type = "int",   stat = "FACTORYSLOT0"                   },
    MPX_FACTORYSLOT1                = { type = "int",   stat = "FACTORYSLOT1"                   },
    MPX_FACTORYSLOT2                = { type = "int",   stat = "FACTORYSLOT2"                   },
    MPX_FACTORYSLOT3                = { type = "int",   stat = "FACTORYSLOT3"                   },
    MPX_FACTORYSLOT4                = { type = "int",   stat = "FACTORYSLOT4"                   },
    MPX_FACTORYSLOT5                = { type = "int",   stat = "FACTORYSLOT5"                   },
    MPX_XM22_LAB_OWNED              = { type = "int",   stat = "XM22_LAB_OWNED"                 },
    MPPLY_OVERALL_BADSPORT          = { type = "float", stat = "MPPLY_OVERALL_BADSPORT"         },
    MPX_PLAYER_MENTAL_STATE         = { type = "float", stat = "PLAYER_MENTAL_STATE"            },
    MPPLY_KILL_DEATH_RATIO          = { type = "float", stat = "MPPLY_KILL_DEATH_RATIO"         },
    MPPLY_CHAR_IS_BADSPORT          = { type = "bool",  stat = "MPPLY_CHAR_IS_BADSPORT"         },
    MPX_AWD_FMKILL3ANDWINGTARACE    = { type = "bool",  stat = "AWD_FMKILL3ANDWINGTARACE"       },
    MPX_AWD_FMWINCUSTOMRACE         = { type = "bool",  stat = "AWD_FMWINCUSTOMRACE"            },
    MPX_CL_RACE_MODDED_CAR          = { type = "bool",  stat = "CL_RACE_MODDED_CAR"             },
    MPX_AWD_FMRACEWORLDRECHOLDER    = { type = "bool",  stat = "AWD_FMRACEWORLDRECHOLDER"       },
    MPX_AWD_FMWINALLRACEMODES       = { type = "bool",  stat = "AWD_FMWINALLRACEMODES"          },
    MPX_AWD_FM_TENNIS_5_SET_WINS    = { type = "bool",  stat = "AWD_FM_TENNIS_5_SET_WINS"       },
    MPX_AWD_FM_TENNIS_STASETWIN     = { type = "bool",  stat = "AWD_FM_TENNIS_STASETWIN"        },
    MPX_AWD_FM_SHOOTRANG_GRAN_WON   = { type = "bool",  stat = "AWD_FM_SHOOTRANG_GRAN_WON"      },
    MPX_AWD_FMWINEVERYGAMEMODE      = { type = "bool",  stat = "AWD_FMWINEVERYGAMEMODE"         },
    MPX_AWD_DAILYOBJWEEKBONUS       = { type = "bool",  stat = "AWD_DAILYOBJWEEKBONUS"          },
    MPX_AWD_DAILYOBJMONTHBONUS      = { type = "bool",  stat = "AWD_DAILYOBJMONTHBONUS"         },
    MPX_CL_DRIVE_RALLY              = { type = "bool",  stat = "CL_DRIVE_RALLY"                 },
    MPX_CL_PLAY_GTA_RACE            = { type = "bool",  stat = "CL_PLAY_GTA_RACE"               },
    MPX_CL_PLAY_BOAT_RACE           = { type = "bool",  stat = "CL_PLAY_BOAT_RACE"              },
    MPX_CL_PLAY_FOOT_RACE           = { type = "bool",  stat = "CL_PLAY_FOOT_RACE"              },
    MPX_CL_PLAY_TEAM_DM             = { type = "bool",  stat = "CL_PLAY_TEAM_DM"                },
    MPX_CL_PLAY_VEHICLE_DM          = { type = "bool",  stat = "CL_PLAY_VEHICLE_DM"             },
    MPX_CL_PLAY_MISSION_CONTACT     = { type = "bool",  stat = "CL_PLAY_MISSION_CONTACT"        },
    MPX_CL_PLAY_A_PLAYLIST          = { type = "bool",  stat = "CL_PLAY_A_PLAYLIST"             },
    MPX_CL_PLAY_POINT_TO_POINT      = { type = "bool",  stat = "CL_PLAY_POINT_TO_POINT"         },
    MPX_CL_PLAY_ONE_ON_ONE_DM       = { type = "bool",  stat = "CL_PLAY_ONE_ON_ONE_DM"          },
    MPX_CL_PLAY_ONE_ON_ONE_RACE     = { type = "bool",  stat = "CL_PLAY_ONE_ON_ONE_RACE"        },
    MPX_CL_SURV_A_BOUNTY            = { type = "bool",  stat = "CL_SURV_A_BOUNTY"               },
    MPX_CL_SET_WANTED_LVL_ON_PLAY   = { type = "bool",  stat = "CL_SET_WANTED_LVL_ON_PLAY"      },
    MPX_CL_GANG_BACKUP_GANGS        = { type = "bool",  stat = "CL_GANG_BACKUP_GANGS"           },
    MPX_CL_GANG_BACKUP_LOST         = { type = "bool",  stat = "CL_GANG_BACKUP_LOST"            },
    MPX_CL_GANG_BACKUP_VAGOS        = { type = "bool",  stat = "CL_GANG_BACKUP_VAGOS"           },
    MPX_CL_CALL_MERCENARIES         = { type = "bool",  stat = "CL_CALL_MERCENARIES"            },
    MPX_CL_PHONE_MECH_DROP_CAR      = { type = "bool",  stat = "CL_PHONE_MECH_DROP_CAR"         },
    MPX_CL_GONE_OFF_RADAR           = { type = "bool",  stat = "CL_GONE_OFF_RADAR"              },
    MPX_CL_FILL_TITAN               = { type = "bool",  stat = "CL_FILL_TITAN"                  },
    MPX_CL_MOD_CAR_USING_APP        = { type = "bool",  stat = "CL_MOD_CAR_USING_APP"           },
    MPX_CL_BUY_INSURANCE            = { type = "bool",  stat = "CL_BUY_INSURANCE"               },
    MPX_CL_BUY_GARAGE               = { type = "bool",  stat = "CL_BUY_GARAGE"                  },
    MPX_CL_ENTER_FRIENDS_HOUSE      = { type = "bool",  stat = "CL_ENTER_FRIENDS_HOUSE"         },
    MPX_CL_CALL_STRIPPER_HOUSE      = { type = "bool",  stat = "CL_CALL_STRIPPER_HOUSE"         },
    MPX_CL_CALL_FRIEND              = { type = "bool",  stat = "CL_CALL_FRIEND"                 },
    MPX_CL_SEND_FRIEND_REQUEST      = { type = "bool",  stat = "CL_SEND_FRIEND_REQUEST"         },
    MPX_CL_W_WANTED_PLAYER_TV       = { type = "bool",  stat = "CL_W_WANTED_PLAYER_TV"          },
    MPX_FM_INTRO_CUT_DONE           = { type = "bool",  stat = "FM_INTRO_CUT_DONE"              },
    MPX_FM_INTRO_MISS_DONE          = { type = "bool",  stat = "FM_INTRO_MISS_DONE"             },
    MPX_SHOOTINGRANGE_SEEN_TUT      = { type = "bool",  stat = "SHOOTINGRANGE_SEEN_TUT"         },
    MPX_TENNIS_SEEN_TUTORIAL        = { type = "bool",  stat = "TENNIS_SEEN_TUTORIAL"           },
    MPX_DARTS_SEEN_TUTORIAL         = { type = "bool",  stat = "DARTS_SEEN_TUTORIAL"            },
    MPX_ARMWRESTLING_SEEN_TUTORIAL  = { type = "bool",  stat = "ARMWRESTLING_SEEN_TUTORIAL"     },
    MPX_HAS_WATCHED_BENNY_CUTSCE    = { type = "bool",  stat = "HAS_WATCHED_BENNY_CUTSCE"       },
    MPX_AWD_FM25DIFFERENTRACES      = { type = "bool",  stat = "AWD_FM25DIFFERENTRACES"         },
    MPX_AWD_FM25DIFFERENTDM         = { type = "bool",  stat = "AWD_FM25DIFFERENTDM"            },
    MPX_AWD_FMATTGANGHQ             = { type = "bool",  stat = "AWD_FMATTGANGHQ"                },
    MPX_AWD_FM6DARTCHKOUT           = { type = "bool",  stat = "AWD_FM6DARTCHKOUT"              },
    MPX_AWD_FM_GOLF_HOLE_IN_1       = { type = "bool",  stat = "AWD_FM_GOLF_HOLE_IN_1"          },
    MPX_AWD_FMPICKUPDLCCRATE1ST     = { type = "bool",  stat = "AWD_FMPICKUPDLCCRATE1ST"        },
    MPX_AWD_FM25DIFITEMSCLOTHES     = { type = "bool",  stat = "AWD_FM25DIFITEMSCLOTHES"        },
    MPX_AWD_BUY_EVERY_GUN           = { type = "bool",  stat = "AWD_BUY_EVERY_GUN"              },
    MPX_AWD_DRIVELESTERCAR5MINS     = { type = "bool",  stat = "AWD_DRIVELESTERCAR5MINS"        },
    MPX_AWD_FMTATTOOALLBODYPARTS    = { type = "bool",  stat = "AWD_FMTATTOOALLBODYPARTS"       },
    MPX_AWD_STORE_20_CAR_IN_GARAGES = { type = "bool",  stat = "AWD_STORE_20_CAR_IN_GARAGES"    },
    MPX_AWD_FMFURTHESTWHEELIE       = { type = "bool",  stat = "AWD_FMFURTHESTWHEELIE"          },
    MPX_AWD_FMFULLYMODDEDCAR        = { type = "bool",  stat = "AWD_FMFULLYMODDEDCAR"           },
    MPX_AWD_FMKILLSTREAKSDM         = { type = "bool",  stat = "AWD_FMKILLSTREAKSDM"            },
    MPX_AWD_FMMOSTKILLSGANGHIDE     = { type = "bool",  stat = "AWD_FMMOSTKILLSGANGHIDE"        },
    MPX_AWD_FMMOSTKILLSSURVIVE      = { type = "bool",  stat = "AWD_FMMOSTKILLSSURVIVE"         },
    MPPLY_AWD_FLEECA_FIN            = { type = "bool",  stat = "MPPLY_AWD_FLEECA_FIN"           },
    MPPLY_AWD_PRISON_FIN            = { type = "bool",  stat = "MPPLY_AWD_PRISON_FIN"           },
    MPPLY_AWD_HUMANE_FIN            = { type = "bool",  stat = "MPPLY_AWD_HUMANE_FIN"           },
    MPPLY_AWD_SERIESA_FIN           = { type = "bool",  stat = "MPPLY_AWD_SERIESA_FIN"          },
    MPPLY_AWD_PACIFIC_FIN           = { type = "bool",  stat = "MPPLY_AWD_PACIFIC_FIN"          },
    MPPLY_AWD_HST_ORDER             = { type = "bool",  stat = "MPPLY_AWD_HST_ORDER"            },
    MPPLY_AWD_COMPLET_HEIST_MEM     = { type = "bool",  stat = "MPPLY_AWD_COMPLET_HEIST_MEM"    },
    MPPLY_AWD_COMPLET_HEIST_1STPER  = { type = "bool",  stat = "MPPLY_AWD_COMPLET_HEIST_1STPER" },
    MPPLY_AWD_HST_SAME_TEAM         = { type = "bool",  stat = "MPPLY_AWD_HST_SAME_TEAM"        },
    MPPLY_AWD_HST_ULT_CHAL          = { type = "bool",  stat = "MPPLY_AWD_HST_ULT_CHAL"         },
    MPX_AWD_FINISH_HEIST_NO_DAMAGE  = { type = "bool",  stat = "AWD_FINISH_HEIST_NO_DAMAGE"     },
    MPX_AWD_SPLIT_HEIST_TAKE_EVENLY = { type = "bool",  stat = "AWD_SPLIT_HEIST_TAKE_EVENLY"    },
    MPX_AWD_ACTIVATE_2_PERSON_KEY   = { type = "bool",  stat = "AWD_ACTIVATE_2_PERSON_KEY"      },
    MPX_AWD_ALL_ROLES_HEIST         = { type = "bool",  stat = "AWD_ALL_ROLES_HEIST"            },
    MPX_AWD_MATCHING_OUTFIT_HEIST   = { type = "bool",  stat = "AWD_MATCHING_OUTFIT_HEIST"      },
    MPX_HEIST_PLANNING_DONE_PRINT   = { type = "bool",  stat = "HEIST_PLANNING_DONE_PRINT"      },
    MPX_HEIST_PLANNING_DONE_HELP_0  = { type = "bool",  stat = "HEIST_PLANNING_DONE_HELP_0"     },
    MPX_HEIST_PLANNING_DONE_HELP_1  = { type = "bool",  stat = "HEIST_PLANNING_DONE_HELP_1"     },
    MPX_HEIST_PRE_PLAN_DONE_HELP_0  = { type = "bool",  stat = "HEIST_PRE_PLAN_DONE_HELP_0"     },
    MPX_HEIST_CUTS_DONE_FINALE      = { type = "bool",  stat = "HEIST_CUTS_DONE_FINALE"         },
    MPX_HEIST_IS_TUTORIAL           = { type = "bool",  stat = "HEIST_IS_TUTORIAL"              },
    MPX_HEIST_STRAND_INTRO_DONE     = { type = "bool",  stat = "HEIST_STRAND_INTRO_DONE"        },
    MPX_HEIST_CUTS_DONE_ORNATE      = { type = "bool",  stat = "HEIST_CUTS_DONE_ORNATE"         },
    MPX_HEIST_CUTS_DONE_PRISON      = { type = "bool",  stat = "HEIST_CUTS_DONE_PRISON"         },
    MPX_HEIST_CUTS_DONE_BIOLAB      = { type = "bool",  stat = "HEIST_CUTS_DONE_BIOLAB"         },
    MPX_HEIST_CUTS_DONE_NARCOTIC    = { type = "bool",  stat = "HEIST_CUTS_DONE_NARCOTIC"       },
    MPX_HEIST_CUTS_DONE_TUTORIAL    = { type = "bool",  stat = "HEIST_CUTS_DONE_TUTORIAL"       },
    MPX_HEIST_AWARD_DONE_PREP       = { type = "bool",  stat = "HEIST_AWARD_DONE_PREP"          },
    MPX_HEIST_AWARD_BOUGHT_IN       = { type = "bool",  stat = "HEIST_AWARD_BOUGHT_IN"          },
    MPPLY_AWD_GANGOPS_IAA           = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_IAA"          },
    MPPLY_AWD_GANGOPS_SUBMARINE     = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_SUBMARINE"    },
    MPPLY_AWD_GANGOPS_MISSILE       = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_MISSILE"      },
    MPPLY_AWD_GANGOPS_ALLINORDER    = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_ALLINORDER"   },
    MPPLY_AWD_GANGOPS_LOYALTY       = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_LOYALTY"      },
    MPPLY_AWD_GANGOPS_LOYALTY2      = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_LOYALTY2"     },
    MPPLY_AWD_GANGOPS_LOYALTY3      = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_LOYALTY3"     },
    MPPLY_AWD_GANGOPS_CRIMMASMD     = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_CRIMMASMD"    },
    MPPLY_AWD_GANGOPS_CRIMMASMD2    = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_CRIMMASMD2"   },
    MPPLY_AWD_GANGOPS_CRIMMASMD3    = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_CRIMMASMD3"   },
    MPPLY_AWD_GANGOPS_SUPPORT       = { type = "bool",  stat = "MPPLY_AWD_GANGOPS_SUPPORT"      },
    MPX_AWD_CLUB_HOTSPOT            = { type = "bool",  stat = "AWD_CLUB_HOTSPOT"               },
    MPX_AWD_CLUB_CLUBBER            = { type = "bool",  stat = "AWD_CLUB_CLUBBER"               },
    MPX_AWD_CLUB_COORD              = { type = "bool",  stat = "AWD_CLUB_COORD"                 },
    MPX_AWD_BEGINNER                = { type = "bool",  stat = "AWD_BEGINNER"                   },
    MPX_AWD_FIELD_FILLER            = { type = "bool",  stat = "AWD_FIELD_FILLER"               },
    MPX_AWD_ARMCHAIR_RACER          = { type = "bool",  stat = "AWD_ARMCHAIR_RACER"             },
    MPX_AWD_LEARNER                 = { type = "bool",  stat = "AWD_LEARNER"                    },
    MPX_AWD_SUNDAY_DRIVER           = { type = "bool",  stat = "AWD_SUNDAY_DRIVER"              },
    MPX_AWD_THE_ROOKIE              = { type = "bool",  stat = "AWD_THE_ROOKIE"                 },
    MPX_AWD_BUMP_AND_RUN            = { type = "bool",  stat = "AWD_BUMP_AND_RUN"               },
    MPX_AWD_GEAR_HEAD               = { type = "bool",  stat = "AWD_GEAR_HEAD"                  },
    MPX_AWD_DOOR_SLAMMER            = { type = "bool",  stat = "AWD_DOOR_SLAMMER"               },
    MPX_AWD_HOT_LAP                 = { type = "bool",  stat = "AWD_HOT_LAP"                    },
    MPX_AWD_ARENA_AMATEUR           = { type = "bool",  stat = "AWD_ARENA_AMATEUR"              },
    MPX_AWD_PAINT_TRADER            = { type = "bool",  stat = "AWD_PAINT_TRADER"               },
    MPX_AWD_SHUNTER                 = { type = "bool",  stat = "AWD_SHUNTER"                    },
    MPX_AWD_JOCK                    = { type = "bool",  stat = "AWD_JOCK"                       },
    MPX_AWD_WARRIOR                 = { type = "bool",  stat = "AWD_WARRIOR"                    },
    MPX_AWD_T_BONE                  = { type = "bool",  stat = "AWD_T_BONE"                     },
    MPX_AWD_MAYHEM                  = { type = "bool",  stat = "AWD_MAYHEM"                     },
    MPX_AWD_WRECKER                 = { type = "bool",  stat = "AWD_WRECKER"                    },
    MPX_AWD_CRASH_COURSE            = { type = "bool",  stat = "AWD_CRASH_COURSE"               },
    MPX_AWD_ARENA_LEGEND            = { type = "bool",  stat = "AWD_ARENA_LEGEND"               },
    MPX_AWD_PEGASUS                 = { type = "bool",  stat = "AWD_PEGASUS"                    },
    MPX_AWD_UNSTOPPABLE             = { type = "bool",  stat = "AWD_UNSTOPPABLE"                },
    MPX_AWD_CONTACT_SPORT           = { type = "bool",  stat = "AWD_CONTACT_SPORT"              },
    MPX_AWD_FIRST_TIME1             = { type = "bool",  stat = "AWD_FIRST_TIME1"                },
    MPX_AWD_FIRST_TIME2             = { type = "bool",  stat = "AWD_FIRST_TIME2"                },
    MPX_AWD_FIRST_TIME3             = { type = "bool",  stat = "AWD_FIRST_TIME3"                },
    MPX_AWD_FIRST_TIME4             = { type = "bool",  stat = "AWD_FIRST_TIME4"                },
    MPX_AWD_FIRST_TIME5             = { type = "bool",  stat = "AWD_FIRST_TIME5"                },
    MPX_AWD_FIRST_TIME6             = { type = "bool",  stat = "AWD_FIRST_TIME6"                },
    MPX_AWD_ALL_IN_ORDER            = { type = "bool",  stat = "AWD_ALL_IN_ORDER"               },
    MPX_AWD_SUPPORTING_ROLE         = { type = "bool",  stat = "AWD_SUPPORTING_ROLE"            },
    MPX_AWD_LEADER                  = { type = "bool",  stat = "AWD_LEADER"                     },
    MPX_AWD_SURVIVALIST             = { type = "bool",  stat = "AWD_SURVIVALIST"                },
    MPX_CAS_VEHICLE_REWARD          = { type = "bool",  stat = "CAS_VEHICLE_REWARD"             },
    MPX_AWD_SCOPEOUT                = { type = "bool",  stat = "AWD_SCOPEOUT"                   },
    MPX_AWD_CREWEDUP                = { type = "bool",  stat = "AWD_CREWEDUP"                   },
    MPX_AWD_MOVINGON                = { type = "bool",  stat = "AWD_MOVINGON"                   },
    MPX_AWD_PROMOCAMP               = { type = "bool",  stat = "AWD_PROMOCAMP"                  },
    MPX_AWD_GUNMAN                  = { type = "bool",  stat = "AWD_GUNMAN"                     },
    MPX_AWD_SMASHNGRAB              = { type = "bool",  stat = "AWD_SMASHNGRAB"                 },
    MPX_AWD_INPLAINSI               = { type = "bool",  stat = "AWD_INPLAINSI"                  },
    MPX_AWD_UNDETECTED              = { type = "bool",  stat = "AWD_UNDETECTED"                 },
    MPX_AWD_ALLROUND                = { type = "bool",  stat = "AWD_ALLROUND"                   },
    MPX_AWD_ELITETHEIF              = { type = "bool",  stat = "AWD_ELITETHEIF"                 },
    MPX_AWD_PRO                     = { type = "bool",  stat = "AWD_PRO"                        },
    MPX_AWD_SUPPORTACT              = { type = "bool",  stat = "AWD_SUPPORTACT"                 },
    MPX_AWD_SHAFTED                 = { type = "bool",  stat = "AWD_SHAFTED"                    },
    MPX_AWD_COLLECTOR               = { type = "bool",  stat = "AWD_COLLECTOR"                  },
    MPX_AWD_DEADEYE                 = { type = "bool",  stat = "AWD_DEADEYE"                    },
    MPX_AWD_PISTOLSATDAWN           = { type = "bool",  stat = "AWD_PISTOLSATDAWN"              },
    MPX_AWD_TRAFFICAVOI             = { type = "bool",  stat = "AWD_TRAFFICAVOI"                },
    MPX_AWD_CANTCATCHBRA            = { type = "bool",  stat = "AWD_CANTCATCHBRA"               },
    MPX_AWD_WIZHARD                 = { type = "bool",  stat = "AWD_WIZHARD"                    },
    MPX_AWD_APEESCAPE               = { type = "bool",  stat = "AWD_APEESCAPE"                  },
    MPX_AWD_MONKEYKIND              = { type = "bool",  stat = "AWD_MONKEYKIND"                 },
    MPX_AWD_AQUAAPE                 = { type = "bool",  stat = "AWD_AQUAAPE"                    },
    MPX_AWD_KEEPFAITH               = { type = "bool",  stat = "AWD_KEEPFAITH"                  },
    MPX_AWD_vLOVE                   = { type = "bool",  stat = "AWD_vLOVE"                      },
    MPX_AWD_NEMESIS                 = { type = "bool",  stat = "AWD_NEMESIS"                    },
    MPX_AWD_FRIENDZONED             = { type = "bool",  stat = "AWD_FRIENDZONED"                },
    MPX_VCM_FLOW_CS_RSC_SEEN        = { type = "bool",  stat = "VCM_FLOW_CS_RSC_SEEN"           },
    MPX_VCM_FLOW_CS_BWL_SEEN        = { type = "bool",  stat = "VCM_FLOW_CS_BWL_SEEN"           },
    MPX_VCM_FLOW_CS_MTG_SEEN        = { type = "bool",  stat = "VCM_FLOW_CS_MTG_SEEN"           },
    MPX_VCM_FLOW_CS_OIL_SEEN        = { type = "bool",  stat = "VCM_FLOW_CS_OIL_SEEN"           },
    MPX_VCM_FLOW_CS_DEF_SEEN        = { type = "bool",  stat = "VCM_FLOW_CS_DEF_SEEN"           },
    MPX_VCM_FLOW_CS_FIN_SEEN        = { type = "bool",  stat = "VCM_FLOW_CS_FIN_SEEN"           },
    MPX_HELP_FURIA                  = { type = "bool",  stat = "HELP_FURIA"                     },
    MPX_HELP_MINITAN                = { type = "bool",  stat = "HELP_MINITAN"                   },
    MPX_HELP_YOSEMITE2              = { type = "bool",  stat = "HELP_YOSEMITE2"                 },
    MPX_HELP_ZHABA                  = { type = "bool",  stat = "HELP_ZHABA"                     },
    MPX_HELP_IMORGEN                = { type = "bool",  stat = "HELP_IMORGEN"                   },
    MPX_HELP_SULTAN2                = { type = "bool",  stat = "HELP_SULTAN2"                   },
    MPX_HELP_VAGRANT                = { type = "bool",  stat = "HELP_VAGRANT"                   },
    MPX_HELP_VSTR                   = { type = "bool",  stat = "HELP_VSTR"                      },
    MPX_HELP_STRYDER                = { type = "bool",  stat = "HELP_STRYDER"                   },
    MPX_HELP_SUGOI                  = { type = "bool",  stat = "HELP_SUGOI"                     },
    MPX_HELP_KANJO                  = { type = "bool",  stat = "HELP_KANJO"                     },
    MPX_HELP_FORMULA                = { type = "bool",  stat = "HELP_FORMULA"                   },
    MPX_HELP_FORMULA2               = { type = "bool",  stat = "HELP_FORMULA2"                  },
    MPX_HELP_JB7002                 = { type = "bool",  stat = "HELP_JB7002"                    },
    MPX_AWD_APEESCAP                = { type = "bool",  stat = "AWD_APEESCAP"                   },
    MPX_IAP_CHALLENGE_0             = { type = "bool",  stat = "IAP_CHALLENGE_0"                },
    MPX_IAP_CHALLENGE_1             = { type = "bool",  stat = "IAP_CHALLENGE_1"                },
    MPX_IAP_CHALLENGE_2             = { type = "bool",  stat = "IAP_CHALLENGE_2"                },
    MPX_IAP_CHALLENGE_3             = { type = "bool",  stat = "IAP_CHALLENGE_3"                },
    MPX_IAP_CHALLENGE_4             = { type = "bool",  stat = "IAP_CHALLENGE_4"                },
    MPX_IAP_GOLD_TANK               = { type = "bool",  stat = "IAP_GOLD_TANK"                  },
    MPX_SCGW_WON_NO_DEATHS          = { type = "bool",  stat = "SCGW_WON_NO_DEATHS"             },
    MPX_AWD_KINGOFQUB3D             = { type = "bool",  stat = "AWD_KINGOFQUB3D"                },
    MPX_AWD_QUBISM                  = { type = "bool",  stat = "AWD_QUBISM"                     },
    MPX_AWD_QUIBITS                 = { type = "bool",  stat = "AWD_QUIBITS"                    },
    MPX_AWD_GODOFQUB3D              = { type = "bool",  stat = "AWD_GODOFQUB3D"                 },
    MPX_AWD_ELEVENELEVEN            = { type = "bool",  stat = "AWD_ELEVENELEVEN"               },
    MPX_AWD_GOFOR11TH               = { type = "bool",  stat = "AWD_GOFOR11TH"                  },
    MPX_AWD_INTELGATHER             = { type = "bool",  stat = "AWD_INTELGATHER"                },
    MPX_AWD_COMPOUNDINFILT          = { type = "bool",  stat = "AWD_COMPOUNDINFILT"             },
    MPX_AWD_LOOT_FINDER             = { type = "bool",  stat = "AWD_LOOT_FINDER"                },
    MPX_AWD_MAX_DISRUPT             = { type = "bool",  stat = "AWD_MAX_DISRUPT"                },
    MPX_AWD_THE_ISLAND_HEIST        = { type = "bool",  stat = "AWD_THE_ISLAND_HEIST"           },
    MPX_AWD_GOING_ALONE             = { type = "bool",  stat = "AWD_GOING_ALONE"                },
    MPX_AWD_TEAM_WORK               = { type = "bool",  stat = "AWD_TEAM_WORK"                  },
    MPX_AWD_MIXING_UP               = { type = "bool",  stat = "AWD_MIXING_UP"                  },
    MPX_AWD_PRO_THIEF               = { type = "bool",  stat = "AWD_PRO_THIEF"                  },
    MPX_AWD_CAT_BURGLAR             = { type = "bool",  stat = "AWD_CAT_BURGLAR"                },
    MPX_AWD_ONE_OF_THEM             = { type = "bool",  stat = "AWD_ONE_OF_THEM"                },
    MPX_AWD_GOLDEN_GUN              = { type = "bool",  stat = "AWD_GOLDEN_GUN"                 },
    MPX_AWD_ELITE_THIEF             = { type = "bool",  stat = "AWD_ELITE_THIEF"                },
    MPX_AWD_PROFESSIONAL            = { type = "bool",  stat = "AWD_PROFESSIONAL"               },
    MPX_AWD_HELPING_OUT             = { type = "bool",  stat = "AWD_HELPING_OUT"                },
    MPX_AWD_COURIER                 = { type = "bool",  stat = "AWD_COURIER"                    },
    MPX_AWD_PARTY_VIBES             = { type = "bool",  stat = "AWD_PARTY_VIBES"                },
    MPX_AWD_HELPING_HAND            = { type = "bool",  stat = "AWD_HELPING_HAND"               },
    MPX_COMPLETE_H4_F_USING_VETIR   = { type = "bool",  stat = "COMPLETE_H4_F_USING_VETIR"      },
    MPX_COMPLETE_H4_F_USING_LONGFIN = { type = "bool",  stat = "COMPLETE_H4_F_USING_LONGFIN"    },
    MPX_COMPLETE_H4_F_USING_ANNIH   = { type = "bool",  stat = "COMPLETE_H4_F_USING_ANNIH"      },
    MPX_COMPLETE_H4_F_USING_ALKONOS = { type = "bool",  stat = "COMPLETE_H4_F_USING_ALKONOS"    },
    MPX_COMPLETE_H4_F_USING_PATROLB = { type = "bool",  stat = "COMPLETE_H4_F_USING_PATROLB"    },
    MPX_AWD_CAR_CLUB                = { type = "bool",  stat = "AWD_CAR_CLUB"                   },
    MPX_AWD_PRO_CAR_EXPORT          = { type = "bool",  stat = "AWD_PRO_CAR_EXPORT"             },
    MPX_AWD_UNION_DEPOSITORY        = { type = "bool",  stat = "AWD_UNION_DEPOSITORY"           },
    MPX_AWD_MILITARY_CONVOY         = { type = "bool",  stat = "AWD_MILITARY_CONVOY"            },
    MPX_AWD_FLEECA_BANK             = { type = "bool",  stat = "AWD_FLEECA_BANK"                },
    MPX_AWD_FREIGHT_TRAIN           = { type = "bool",  stat = "AWD_FREIGHT_TRAIN"              },
    MPX_AWD_BOLINGBROKE_ASS         = { type = "bool",  stat = "AWD_BOLINGBROKE_ASS"            },
    MPX_AWD_IAA_RAID                = { type = "bool",  stat = "AWD_IAA_RAID"                   },
    MPX_AWD_METH_JOB                = { type = "bool",  stat = "AWD_METH_JOB"                   },
    MPX_AWD_BUNKER_RAID             = { type = "bool",  stat = "AWD_BUNKER_RAID"                },
    MPX_AWD_STRAIGHT_TO_VIDEO       = { type = "bool",  stat = "AWD_STRAIGHT_TO_VIDEO"          },
    MPX_AWD_MONKEY_C_MONKEY_DO      = { type = "bool",  stat = "AWD_MONKEY_C_MONKEY_DO"         },
    MPX_AWD_TRAINED_TO_KILL         = { type = "bool",  stat = "AWD_TRAINED_TO_KILL"            },
    MPX_AWD_DIRECTOR                = { type = "bool",  stat = "AWD_DIRECTOR"                   },
    MPX_AWD_TEEING_OFF              = { type = "bool",  stat = "AWD_TEEING_OFF"                 },
    MPX_AWD_PARTY_NIGHT             = { type = "bool",  stat = "AWD_PARTY_NIGHT"                },
    MPX_AWD_BILLIONAIRE_GAMES       = { type = "bool",  stat = "AWD_BILLIONAIRE_GAMES"          },
    MPX_AWD_HOOD_PASS               = { type = "bool",  stat = "AWD_HOOD_PASS"                  },
    MPX_AWD_STUDIO_TOUR             = { type = "bool",  stat = "AWD_STUDIO_TOUR"                },
    MPX_AWD_DONT_MESS_DRE           = { type = "bool",  stat = "AWD_DONT_MESS_DRE"              },
    MPX_AWD_BACKUP                  = { type = "bool",  stat = "AWD_BACKUP"                     },
    MPX_AWD_SHORTFRANK_1            = { type = "bool",  stat = "AWD_SHORTFRANK_1"               },
    MPX_AWD_SHORTFRANK_2            = { type = "bool",  stat = "AWD_SHORTFRANK_2"               },
    MPX_AWD_SHORTFRANK_3            = { type = "bool",  stat = "AWD_SHORTFRANK_3"               },
    MPX_AWD_CONTR_KILLER            = { type = "bool",  stat = "AWD_CONTR_KILLER"               },
    MPX_AWD_DOGS_BEST_FRIEND        = { type = "bool",  stat = "AWD_DOGS_BEST_FRIEND"           },
    MPX_AWD_MUSIC_STUDIO            = { type = "bool",  stat = "AWD_MUSIC_STUDIO"               },
    MPX_AWD_SHORTLAMAR_1            = { type = "bool",  stat = "AWD_SHORTLAMAR_1"               },
    MPX_AWD_SHORTLAMAR_2            = { type = "bool",  stat = "AWD_SHORTLAMAR_2"               },
    MPX_AWD_SHORTLAMAR_3            = { type = "bool",  stat = "AWD_SHORTLAMAR_3"               },
    MPX_BS_FRANKLIN_DIALOGUE_0      = { type = "bool",  stat = "BS_FRANKLIN_DIALOGUE_0"         },
    MPX_BS_FRANKLIN_DIALOGUE_1      = { type = "bool",  stat = "BS_FRANKLIN_DIALOGUE_1"         },
    MPX_BS_FRANKLIN_DIALOGUE_2      = { type = "bool",  stat = "BS_FRANKLIN_DIALOGUE_2"         },
    MPX_BS_IMANI_D_APP_SETUP        = { type = "bool",  stat = "BS_IMANI_D_APP_SETUP"           },
    MPX_BS_IMANI_D_APP_STRAND       = { type = "bool",  stat = "BS_IMANI_D_APP_STRAND"          },
    MPX_BS_IMANI_D_APP_PARTY        = { type = "bool",  stat = "BS_IMANI_D_APP_PARTY"           },
    MPX_BS_IMANI_D_APP_PARTY_2      = { type = "bool",  stat = "BS_IMANI_D_APP_PARTY_2"         },
    MPX_BS_IMANI_D_APP_PARTY_F      = { type = "bool",  stat = "BS_IMANI_D_APP_PARTY_F"         },
    MPX_BS_IMANI_D_APP_BILL         = { type = "bool",  stat = "BS_IMANI_D_APP_BILL"            },
    MPX_BS_IMANI_D_APP_BILL_2       = { type = "bool",  stat = "BS_IMANI_D_APP_BILL_2"          },
    MPX_BS_IMANI_D_APP_BILL_F       = { type = "bool",  stat = "BS_IMANI_D_APP_BILL_F"          },
    MPX_BS_IMANI_D_APP_HOOD         = { type = "bool",  stat = "BS_IMANI_D_APP_HOOD"            },
    MPX_BS_IMANI_D_APP_HOOD_2       = { type = "bool",  stat = "BS_IMANI_D_APP_HOOD_2"          },
    MPX_BS_IMANI_D_APP_HOOD_F       = { type = "bool",  stat = "BS_IMANI_D_APP_HOOD_F"          },
    MPX_AWD_ACELIQUOR               = { type = "bool",  stat = "AWD_ACELIQUOR"                  },
    MPX_AWD_TRUCKAMBUSH             = { type = "bool",  stat = "AWD_TRUCKAMBUSH"                },
    MPX_AWD_LOSTCAMPREV             = { type = "bool",  stat = "AWD_LOSTCAMPREV"                },
    MPX_AWD_ACIDTRIP                = { type = "bool",  stat = "AWD_ACIDTRIP"                   },
    MPX_AWD_HIPPYRIVALS             = { type = "bool",  stat = "AWD_HIPPYRIVALS"                },
    MPX_AWD_TRAINCRASH              = { type = "bool",  stat = "AWD_TRAINCRASH"                 },
    MPX_AWD_BACKUPB                 = { type = "bool",  stat = "AWD_BACKUPB"                    },
    MPX_AWD_GETSTARTED              = { type = "bool",  stat = "AWD_GETSTARTED"                 },
    MPX_AWD_CHEMREACTION            = { type = "bool",  stat = "AWD_CHEMREACTION"               },
    MPX_AAWD_WAREHODEFEND           = { type = "bool",  stat = "AAWD_WAREHODEFEND"              },
    MPX_AWD_ATTACKINVEST            = { type = "bool",  stat = "AWD_ATTACKINVEST"               },
    MPX_AWD_RESCUECOOK              = { type = "bool",  stat = "AWD_RESCUECOOK"                 },
    MPX_AWD_DRUGTRIPREHAB           = { type = "bool",  stat = "AWD_DRUGTRIPREHAB"              },
    MPX_AWD_CARGOPLANE              = { type = "bool",  stat = "AWD_CARGOPLANE"                 },
    MPX_AWD_BACKUPB2                = { type = "bool",  stat = "AWD_BACKUPB2"                   },
    MPX_AWD_TAXISTAR                = { type = "bool",  stat = "AWD_TAXISTAR"                   },
    MPX_AWD_MAZE_BANK_ROBBERY       = { type = "bool",  stat = "AWD_MAZE_BANK_ROBBERY"          },
    MPX_AWD_CARGO_SHIP_ROBBERY      = { type = "bool",  stat = "AWD_CARGO_SHIP_ROBBERY"         },
    MPX_AWD_DIAMOND_CASINO_ROBBERY  = { type = "bool",  stat = "AWD_DIAMOND_CASINO_ROBBERY"     },
    MPX_AWD_MISSION_ROW_ROBBERY     = { type = "bool",  stat = "AWD_MISSION_ROW_ROBBERY"        },
    MPX_AWD_SUBMARINE_ROBBERY       = { type = "bool",  stat = "AWD_SUBMARINE_ROBBERY"          },
    MPX_AWD_PERFECT_RUN             = { type = "bool",  stat = "AWD_PERFECT_RUN"                },
    MPX_AWD_EXTRA_MILE              = { type = "bool",  stat = "AWD_EXTRA_MILE"                 },
    MPX_AWD_BOLINGBROKE             = { type = "bool",  stat = "AWD_BOLINGBROKE"                },
    MPX_AWD_GETTING_SET_UP          = { type = "bool",  stat = "AWD_GETTING_SET_UP"             },
    MPX_AWD_CHICKEN_FACTORY_RAID    = { type = "bool",  stat = "AWD_CHICKEN_FACTORY_RAID"       },
    MPX_AWD_HELPING_HAND2           = { type = "bool",  stat = "AWD_HELPING_HAND2"              },
    MPX_AWD_SURPRISE_ATTACK         = { type = "bool",  stat = "AWD_SURPRISE_ATTACK"            },
    MPX_AWD_ALL_OUT_RAID            = { type = "bool",  stat = "AWD_ALL_OUT_RAID"               },
    MPX_AWD_WEAPON_ARSENAL          = { type = "bool",  stat = "AWD_WEAPON_ARSENAL"             },
    MPX_SR_TIER_1_REWARD            = { type = "bool",  stat = "SR_TIER_1_REWARD"               },
    MPX_SR_TIER_3_REWARD            = { type = "bool",  stat = "SR_TIER_3_REWARD"               },
    MPX_SR_INCREASE_THROW_CAP       = { type = "bool",  stat = "SR_INCREASE_THROW_CAP"          },
    MPX_CARMEET_PV_CHLLGE_CMPLT     = { type = "bool",  stat = "CARMEET_PV_CHLLGE_CMPLT"        },
    MPX_CARMEET_PV_CLMED            = { type = "bool",  stat = "CARMEET_PV_CLMED"               },
    MPPLY_AWD_HST_ORDER             = { type = "bool",  stat = "MPPLY_AWD_HST_ORDER"            },
    MPPLY_AWD_HST_SAME_TEAM         = { type = "bool",  stat = "MPPLY_AWD_HST_SAME_TEAM"        },
    MPPLY_AWD_HST_ULT_CHAL          = { type = "bool",  stat = "MPPLY_AWD_HST_ULT_CHAL"         }
}

--#endregion

--#region ePackedBool

ePackedBool = {
    HAS_PARSED = false,

    Business = {
        Arcade = {
            Setup = { 27227 }
        },

        CrateWarehouse = {
            Cargo = { 32359, 32363 }
        },

        Hangar = {
            Cargo = { 36828 }
        },

        Nightclub = {
            Setup = {
                Staff     = { 18161 },
                Equipment = { 22067 },
                DJ        = { 22068 }
            }
        }
    },

    Clothes = {
        DiamondCasino = { 28225, 28248 },

        Parachutes = {
            Part1 = { 3609         },
            Part2 = { 31791, 31796 },
            Part3 = { 34378, 34379 }
        }
    },

    Player = {
        Awards = {
            Doomsday            = { 18098, 18161 },
            AfterHours          = { 22066, 22193 },
            ArenaWar            = { 24962, 25537 },
            DiamondCasinoResort = { 26810, 27257 },
            DiamondCasino       = { 28098, 28353 },
            SummerSpecial       = { 30227, 30482 },
            CayoPerico          = { 30515, 30706 },
            Tuners              = { 31707, 32282 },
            Contract            = { 32283, 32474 }
        }
    },

    Vehicle = {
        Unlock = {
            ArenaWar = { 24992, 24999 }
        },

        TradePrices = {
            ArenaWarVehicles = { 24963, 25109 },
            Headlights       = { 24980, 24991 }
        }
    },

    Weapon = {
        Livery = {
            DildodudeMicroSMG    = { 36788 },
            DildodudePumpShotgun = { 36787 },
            EmployeeMicroSMG     = { 41657 },
            SantaHeavySniper     = { 42069 },
            SeasonPistolMkII     = { 36786 },
            SkullSpecialCarbine  = { 42122 },
            SnowmanCombatPistol  = { 42068 },
            SuedeCarbineRifle    = { 41658 },
            UncleRPG             = { 41659 }
        }
    }
}

--#endregion

--#region eTable

eTable = {
    HAS_PARSED = false,

    Business = {
        Hangar = {
            Cargoes = {
                { name = "Animal Materials",  index = 1 },
                { name = "Art n Antiques",    index = 2 },
                { name = "Chemicals",         index = 3 },
                { name = "Counterfeit Goods", index = 4 },
                { name = "Jewel n Gems",      index = 5 },
                { name = "Medical Supplies",  index = 6 },
                { name = "Narcotics",         index = 7 },
                { name = "Tabacco n Alcohol", index = 8 },
            }
        },

        Nightclub = {
            Cargoes = {
                { name = "Cargo n Shipments",  index = "HUB_PROD_TOTAL_0" },
                { name = "Sporting Goods",     index = "HUB_PROD_TOTAL_1" },
                { name = "S.A. Imports",       index = "HUB_PROD_TOTAL_2" },
                { name = "Pharmac. Research",  index = "HUB_PROD_TOTAL_3" },
                { name = "Organic Produce",    index = "HUB_PROD_TOTAL_4" },
                { name = "Printing n Copying", index = "HUB_PROD_TOTAL_5" },
                { name = "Cash Creation",      index = "HUB_PROD_TOTAL_6" },
            }
        },

        Supplies = {}
    },

    Heist = {
        Generic = {
            Team = {
                { name = "Solo",  index = 1 },
                { name = "Duo",   index = 2 },
                { name = "Trio",  index = 3 },
                { name = "Squad", index = 4 }
            }
        },

        Agency = {
            Contracts = {
                { name = "None",           index = 3    },
                { name = "Nightclub",      index = 4    },
                { name = "Marina",         index = 12   },
                { name = "Nightlife Leak", index = 28   },
                { name = "Country Club",   index = 60   },
                { name = "Guest List",     index = 123  },
                { name = "High Soc. Leak", index = 254  },
                { name = "Davis",          index = 508  },
                { name = "Ballas",         index = 1020 },
                { name = "Sou. Cen. Leak", index = 2044 },
                { name = "Studio Time",    index = 2045 },
                { name = "Don't # W. Dre", index = 4095 }
            }
        },

        Apartment = {
            Team = {
                { name = "Solo",  index = 1 },
                { name = "Duo",   index = 2 },
                { name = "Squad", index = 4 }
            },

            Receivers = {
                { name = "All",       index = 0 },
                { name = "Only Crew", index = 1 },
                { name = "Only Me",   index = 2 }
            },

            Presets = {
                { name = "All - 0%",    index = 0   },
                { name = "All - 85%",   index = 85  },
                { name = "All - 100%",  index = 100 },
                { name = "3mil Payout", index = -1  }
            },

            Heists = {
                FleecaJob   = 1328892776,
                PrisonBreak = 964111671,
                HumaneLabs  = 1131632450,
                SeriesA     = 1967927346,
                PacificJob  = 1182286714
            }
        },

        AutoShop = {
            Contracts = {
                { name = "None",            index = -1 },
                { name = "Union Deposit.",  index = 0  },
                { name = "Superdol. Deal",  index = 1  },
                { name = "Bank Contract",   index = 2  },
                { name = "ECU Job",         index = 3  },
                { name = "Prison Contrac.", index = 4  },
                { name = "Agency Deal",     index = 5  },
                { name = "Lost Contract",   index = 6  },
                { name = "Data Contract",   index = 7  }
            }
        },

        CayoPerico = {
            Difficulties = {
                { name = "Normal", index = 126823 },
                { name = "Hard",   index = 131055 }
            },

            Approaches = {
                { name = "Kosatka",        index = 65283 },
                { name = "Alkonost",       index = 65413 },
                { name = "Velum",          index = 65289 },
                { name = "Stealth Annih.", index = 65425 },
                { name = "Patrol Boat",    index = 65313 },
                { name = "Longfin",        index = 65345 },
                { name = "All Ways",       index = 65535 }
            },

            Loadouts = {
                { name = "Aggressor",   index = 1 },
                { name = "Conspirator", index = 2 },
                { name = "Crackshot",   index = 3 },
                { name = "Saboteur",    index = 4 },
                { name = "Marksman",    index = 5 },
            },

            Targets = {
                Primary = {
                    { name = "Sinsimito Tequil.", index = 0 },
                    { name = "Ruby Necklace",     index = 1 },
                    { name = "Bearer Bonds",      index = 2 },
                    { name = "Pink Diamond",      index = 3 },
                    { name = "Madrazo Files",     index = 4 },
                    { name = "Panther Statue",    index = 5 }
                },
                Secondary = {
                    { name = "None", index = 0      },
                    { name = "Cash", index = "CASH" },
                    { name = "Weed", index = "WEED" },
                    { name = "Coke", index = "COKE" },
                    { name = "Gold", index = "GOLD" }
                },
                Amounts = {
                    Compound = {
                        { name = "Empty", index = 0   },
                        { name = "Full",  index = 255 },
                        { name = "1",     index = 128 },
                        { name = "2",     index = 64  },
                        { name = "3",     index = 196 },
                        { name = "4",     index = 204 },
                        { name = "5",     index = 220 },
                        { name = "6",     index = 252 },
                        { name = "7",     index = 253 }
                    },
                    Island = {
                        { name = "Empty", index = 0        },
                        { name = "Full",  index = 16777215 },
                        { name = "1",     index = 8388608  },
                        { name = "2",     index = 12582912 },
                        { name = "3",     index = 12845056 },
                        { name = "4",     index = 12976128 },
                        { name = "5",     index = 13500416 },
                        { name = "6",     index = 14548992 },
                        { name = "7",     index = 16646144 },
                        { name = "8",     index = 16711680 },
                        { name = "9",     index = 16744448 },
                        { name = "10",    index = 16760832 },
                        { name = "11",    index = 16769024 },
                        { name = "12",    index = 16769536 },
                        { name = "13",    index = 16770560 },
                        { name = "14",    index = 16770816 },
                        { name = "15",    index = 16770880 },
                        { name = "16",    index = 16771008 },
                        { name = "17",    index = 16773056 },
                        { name = "18",    index = 16777152 },
                        { name = "19",    index = 16777184 },
                        { name = "20",    index = 16777200 },
                        { name = "21",    index = 16777202 },
                        { name = "22",    index = 16777203 },
                        { name = "23",    index = 16777211 }
                    },
                    Arts = {
                        { name = "Empty", index = 0   },
                        { name = "Full",  index = 127 },
                        { name = "1",     index = 64  },
                        { name = "2",     index = 96  },
                        { name = "3",     index = 112 },
                        { name = "4",     index = 120 },
                        { name = "5",     index = 122 },
                        { name = "6",     index = 126 }
                    }
                }
            },

            Presets = {
                { name = "All - 0%",       index = 0   },
                { name = "All - 85%",      index = 85  },
                { name = "All - 100%",     index = 100 },
                { name = "2.55mil Payout", index = -1  }
            },

            Values = {
                Cash = 83250,
                Weed = 135000,
                Coke = 202500,
                Gold = 333333,
                Arts = 180000
            },

            Files = {}
        },

        DiamondCasino = {
            Difficulties = {
                { name = "Normal", index = 0 },
                { name = "Hard",   index = 1 }
            },

            Approaches = {
                { name = "Silent n Snea.", index = 1 },
                { name = "Big Con",        index = 2 },
                { name = "Aggressive",     index = 3 }
            },

            Gunmans = {
                { name = "Karl Abolaji",    index = 1 },
                { name = "Charlie Reed",    index = 3 },
                { name = "Patrick McRear.", index = 5 },
                { name = "Gustavo Mota",    index = 2 },
                { name = "Chester McCoy",   index = 4 }
            },

            Loadouts = {
                { name = "Micro SMG (S)",     index = 1 },
                { name = "Mac. Pistol (S)",   index = 1 },
                { name = "Micro SMG",         index = 1 },
                { name = "Double Barrel",     index = 1 },
                { name = "Sawed-Off",         index = 1 },
                { name = "Heavy Revolver",    index = 1 },
                { name = "Assau. SMG (S)",    index = 3 },
                { name = "Bullpup Sh. (S)",   index = 3 },
                { name = "Machine Pistol",    index = 3 },
                { name = "Sweeper Shot.",     index = 3 },
                { name = "Assault SMG",       index = 3 },
                { name = "Pump Shotgun",      index = 3 },
                { name = "Combat PDW",        index = 5 },
                { name = "Assault Rif. (S)",  index = 5 },
                { name = "Sawed-Off",         index = 5 },
                { name = "Compact Rifle",     index = 5 },
                { name = "Heavy Shotgun",     index = 5 },
                { name = "Combat MG",         index = 5 },
                { name = "Carbin. Rif. (S)",  index = 2 },
                { name = "Assau. Sho. (S)",   index = 2 },
                { name = "Carbine Rifle",     index = 2 },
                { name = "Assault Shot.",     index = 2 },
                { name = "Carbine Rifle",     index = 2 },
                { name = "Assault Shot.",     index = 2 },
                { name = "Pump Sh. II (S)",   index = 4 },
                { name = "Carbine R. II (S)", index = 4 },
                { name = "SMG Mk II",         index = 4 },
                { name = "Bullpup Rifle II",  index = 4 },
                { name = "Pump Shot. II",     index = 4 },
                { name = "Assault Rifle II",  index = 4 }
            },

            Drivers = {
                { name = "Karim Denz",       index = 1 },
                { name = "Zach Nelson",      index = 4 },
                { name = "Taliana Martinez", index = 2 },
                { name = "Eddie Toh",        index = 3 },
                { name = "Chester McCoy",    index = 5 }
            },

            Vehicles = {
                { name = "Issi Classic",    index = 1 },
                { name = "Asbo",            index = 1 },
                { name = "Blista Kanjo",    index = 1 },
                { name = "Sentinel Class.", index = 1 },
                { name = "Manchez",         index = 4 },
                { name = "Stryder",         index = 4 },
                { name = "Defiler",         index = 4 },
                { name = "Lectro",          index = 4 },
                { name = "Retinue Mk II",   index = 2 },
                { name = "Drift Yosemite",  index = 2 },
                { name = "Sugoi",           index = 2 },
                { name = "Jugular",         index = 2 },
                { name = "Sultan Classic",  index = 3 },
                { name = "Gauntl. Classic", index = 3 },
                { name = "Ellie",           index = 3 },
                { name = "Komoda",          index = 3 },
                { name = "Zhaba",           index = 5 },
                { name = "Vagrant",         index = 5 },
                { name = "Outlaw",          index = 5 },
                { name = "Everon",          index = 5 }
            },

            Hackers = {
                { name = "Rickie Lukens",   index = 1 },
                { name = "Yohan Blair",     index = 3 },
                { name = "Christian Feltz", index = 2 },
                { name = "Page Harris",     index = 5 },
                { name = "Avi Schwartz.",   index = 4 }
            },

            Masks = {
                { name = "None",              index = 0  },
                { name = "Geometric Set",     index = 1  },
                { name = "Hunter Set",        index = 2  },
                { name = "Oni Half Mask Set", index = 3  },
                { name = "Emoji Set",         index = 4  },
                { name = "Ornate Skull Set",  index = 5  },
                { name = "Lucky Fruit Set",   index = 6  },
                { name = "Guerilla Set",      index = 7  },
                { name = "Clown Set",         index = 8  },
                { name = "Animal Set",        index = 9  },
                { name = "Riot Set",          index = 10 },
                { name = "Oni Full Mask Set", index = 11 },
                { name = "Hockey Set",        index = 12 }
            },

            Guards = {
                { name = "Elite",  index = 0 },
                { name = "Pro",    index = 1 },
                { name = "Unit",   index = 2 },
                { name = "Rookie", index = 3 }
            },

            Keycards = {
                { name = "None",    index = 0 },
                { name = "Level 1", index = 1 },
                { name = "Level 2", index = 2 }
            },

            Targets = {
                { name = "Cash",     index = 0 },
                { name = "Arts",     index = 2 },
                { name = "Gold",     index = 1 },
                { name = "Diamonds", index = 3 }
            },

            Presets = {
                { name = "All - 0%",      index = 0   },
                { name = "All - 85%",     index = 85  },
                { name = "All - 100%",    index = 100 },
                { name = "3.6mil Payout", index = -1  }
            },

            Files = {}
        },

        Doomsday = {
            Acts = {
                { name = "Data Breaches",     index = 1 },
                { name = "Bogdan Problem",    index = 2 },
                { name = "Doomsday Scenario", index = 3 }
            },

            Presets = {
                { name = "All - 0%",       index = 0   },
                { name = "All - 85%",      index = 85  },
                { name = "All - 100%",     index = 100 },
                { name = "2.55mil Payout", index = -1  }
            },

            Heists = {
                Data     = 503,
                Bogdan   = 240,
                Doomsday = 16368,
            }
        },

        SalvageYard = {
            Robberies = {
                { name = "Cargo Ship", index = 0 },
                { name = "Gangbanger", index = 1 },
                { name = "Duggan",     index = 2 },
                { name = "Podium",     index = 3 },
                { name = "McTony",     index = 4 }
            },

            Vehicles = {
                { name = "LM87",             index = 1   },
                { name = "Cinquemila",       index = 2   },
                { name = "Autarch",          index = 3   },
                { name = "Tigon",            index = 4   },
                { name = "Champion",         index = 5   },
                { name = "10F",              index = 6   },
                { name = "SM722",            index = 7   },
                { name = "Omnis e-GT",       index = 8   },
                { name = "Growler",          index = 9   },
                { name = "Deity",            index = 10  },
                { name = "Itali RSX",        index = 11  },
                { name = "Coquette D10",     index = 12  },
                { name = "Jubilee",          index = 13  },
                { name = "Astron",           index = 14  },
                { name = "Comet S2 Cabr.",   index = 15  },
                { name = "Torero",           index = 16  },
                { name = "Cheetah Classic",  index = 17  },
                { name = "Turismo Classic",  index = 18  },
                { name = "Infernus Classic", index = 19  },
                { name = "Stafford",         index = 20  },
                { name = "GT500",            index = 21  },
                { name = "Viseris",          index = 22  },
                { name = "Mamba",            index = 23  },
                { name = "Coquette Black.",  index = 24  },
                { name = "Stinger GT",       index = 25  },
                { name = "Z-Type",           index = 26  },
                { name = "Broadway",         index = 27  },
                { name = "Vigero ZX",        index = 28  },
                { name = "Buffalo STX",      index = 29  },
                { name = "Ruston",           index = 30  },
                { name = "Gauntl. Hellfire", index = 31  },
                { name = "Dominator GTT",    index = 32  },
                { name = "Roosevelt Valor",  index = 33  },
                { name = "Swinger",          index = 34  },
                { name = "Stirling GT",      index = 35  },
                { name = "Omnis",            index = 36  },
                { name = "Tropos Rallye",    index = 37  },
                { name = "Jugular",          index = 38  },
                { name = "Patriot Mil-Spec", index = 39  },
                { name = "Toros",            index = 40  },
                { name = "Caracara 4x4",     index = 41  },
                { name = "Sentinel Classic", index = 42  },
                { name = "Weevil",           index = 43  },
                { name = "Blista Kanjo",     index = 44  },
                { name = "Eudora",           index = 45  },
                { name = "Kamacho",          index = 46  },
                { name = "Hellion",          index = 47  },
                { name = "Ellie",            index = 48  },
                { name = "Hermes",           index = 49  },
                { name = "Hustler",          index = 50  },
                { name = "Turismo Om.",      index = 51  },
                { name = "Buffalo EVX",      index = 52  },
                { name = "Itali GTO St.",    index = 53  },
                { name = "Virtue",           index = 54  },
                { name = "Ignus",            index = 55  },
                { name = "Zentorno",         index = 56  },
                { name = "Neon",             index = 57  },
                { name = "Furia",            index = 58  },
                { name = "Zorrusso",         index = 59  },
                { name = "Thrax",            index = 60  },
                { name = "Vagner",           index = 61  },
                { name = "Panthere",         index = 62  },
                { name = "Itali GTO",        index = 63  },
                { name = "S80RR",            index = 64  },
                { name = "Tyrant",           index = 65  },
                { name = "Entity MT",        index = 66  },
                { name = "Torero XO",        index = 67  },
                { name = "Neo",              index = 68  },
                { name = "Corsita",          index = 69  },
                { name = "Paragon R",        index = 70  },
                { name = "Franken Stange",   index = 71  },
                { name = "Comet Safari",     index = 72  },
                { name = "FR36",             index = 73  },
                { name = "Hotring Everon",   index = 74  },
                { name = "Komoda",           index = 75  },
                { name = "Tailgater S",      index = 76  },
                { name = "Jester Classic",   index = 77  },
                { name = "Jester RR",        index = 78  },
                { name = "Euros",            index = 79  },
                { name = "ZR350",            index = 80  },
                { name = "Cypher",           index = 81  },
                { name = "Dominator ASP",    index = 82  },
                { name = "Baller ST-D",      index = 83  },
                { name = "Casco",            index = 84  },
                { name = "Drift Yosemite",   index = 85  },
                { name = "Everon",           index = 86  },
                { name = "Penumbra FF",      index = 87  },
                { name = "V-STR",            index = 88  },
                { name = "Dominator GT",     index = 89  },
                { name = "Schlagen GT",      index = 90  },
                { name = "Cavalcade XL",     index = 91  },
                { name = "Clique",           index = 92  },
                { name = "Boor",             index = 93  },
                { name = "Sugoi",            index = 94  },
                { name = "Greenwood",        index = 95  },
                { name = "Brigham",          index = 96  },
                { name = "Issi Rally",       index = 97  },
                { name = "Seminole Fr.",     index = 98  },
                { name = "Kanjo SJ",         index = 99  },
                { name = "Previon",          index = 100 }
            },

            Modifications = {
                { name = "Version 1", index = 0 },
                { name = "Version 2", index = 1 },
                { name = "Version 3", index = 2 },
                { name = "Version 4", index = 3 },
                { name = "Version 5", index = 4 },
            },

            Keeps = {
                { name = "Can't Claim", index = false },
                { name = "Can Claim",   index = true  }
            }
        }
    },

    Cash = {
        Stats = {
            Earneds = {
                { name = "Unselected",       index = 0                                },
                { name = "Total",            index = eStat.MPPLY_TOTAL_EVC            },
                { name = "Jobs",             index = eStat.MPX_MONEY_EARN_JOBS        },
                { name = "Selling Vehicles", index = eStat.MPX_MONEY_EARN_SELLING_VEH },
                { name = "Betting",          index = eStat.MPX_MONEY_EARN_BETTING     },
                { name = "Good Sport",       index = eStat.MPX_MONEY_EARN_GOOD_SPORT  },
                { name = "Picked Up",        index = eStat.MPX_MONEY_EARN_PICKED_UP   }
            },
            Spents = {
                { name = "Unselected",          index = 0                                     },
                { name = "Total",               index = eStat.MPPLY_TOTAL_SVC                 },
                { name = "Weapons n Armor",     index = eStat.MPX_MONEY_SPENT_WEAPON_ARMOR    },
                { name = "Vehicles n Maint.",   index = eStat.MPX_MONEY_SPENT_VEH_MAINTENANCE },
                { name = "Style n Entert.",     index = eStat.MPX_MONEY_SPENT_STYLE_ENT       },
                { name = "Property n Utils",    index = eStat.MPX_MONEY_SPENT_PROPERTY_UTIL   },
                { name = "Job n Ac. Ent. Fees", index = eStat.MPX_MONEY_SPENT_JOB_ACTIVITY    },
                { name = "Betting",             index = eStat.MPX_MONEY_SPENT_BETTING         },
                { name = "Contact Services",    index = eStat.MPX_MONEY_SPENT_CONTACT_SERVICE },
                { name = "Healthcare n Bail",   index = eStat.MPX_MONEY_SPENT_HEALTHCARE      },
                { name = "Dropped or Stolen",   index = eStat.MPX_MONEY_SPENT_DROPPED_STOLEN  }
            }
        }
    },

    Session = {
        Types = {
            Public       = 0,
            NewPublic    = 1,
            ClosedCrew   = 2,
            Crew         = 3,
            ClosedFriend = 4,
            Friend       = 5,
            Solo         = 6,
            Invite       = 7,
            JoinCrew     = 8,
            Offline      = 9
        }
    },

    World = {
        Casino = {
            Prizes = {
                { name = "Clothing 1",   index =  0 },
                { name = "Clothing 2",   index =  8 },
                { name = "Clothing 3",   index = 12 },
                { name = "2,500 RP",     index =  1 },
                { name = "5,000 RP",     index =  5 },
                { name = "7,500 RP",     index =  9 },
                { name = "10,000 RP",    index = 13 },
                { name = "15,000 RP",    index = 17 },
                { name = "$20,000",      index =  2 },
                { name = "$30,000",      index =  6 },
                { name = "$40,000",      index = 14 },
                { name = "$50,000",      index = 19 },
                { name = "10,000 Chips", index =  3 },
                { name = "15,000 Chips", index =  7 },
                { name = "20,000 Chips", index = 10 },
                { name = "25,000 Chips", index = 15 },
                { name = "Discount",     index =  4 },
                { name = "Mystery",      index = 11 },
                { name = "Vehicle",      index = 18 }
            }
        }
    },

    Story = {
        Characters = {
            { name = "Michael",  index = 0 },
            { name = "Franklin", index = 1 },
            { name = "Trevor",   index = 2 }
        }
    },

    Editor = {
        Globals = {
            Types = {
                { name = "int",   index = 0 },
                { name = "float", index = 1 },
                { name = "bool",  index = 2 }
            }
        },

        Locals = {
            Types = {
                { name = "int",   index = 0 },
                { name = "float", index = 1 }
            }
        },

        Stats = {
            Types = {
                { name = "int",   index = 0 },
                { name = "float", index = 1 },
                { name = "bool",  index = 3 }
            },

            Files = {}
        },

        PackedStats = {
            Types = {
                { name = "int",  index = 0 },
                { name = "bool", index = 1 }
            }
        }
    },

    Settings = {
        Logging = {
            { name = "Disabled", index = 0 },
            { name = "Silent",   index = 1 },
            { name = "Enabled",  index = 2 }
        },

        Languages = {},

        InstantFinishes = {
            { name = "Old", index = 0 },
            { name = "New", index = 1 }
        }
    },

    SilentNight = {
        Features = {
            Language = 1984344559
        }
    },

    Cherax = {
        Features = {
            ForceScriptHost   = 1181010276,
            SessionType       = 603923874,
            StartSession      = 3364415752,
            BailFromSession   = 3768410355,
            LogTransactions   = 925637617,
            SubscribedScripts = 3331055146,
            RunScript         = 2423908032,
            StopScript        = 2425713991
        }
    },

    JinxScript = {
        Features = {
            RestartFreemode = 3731619689
        }
    }
}

--#endregion

--#region eNative

eNative = {
    CUTSCENE = {
        STOP_CUTSCENE_IMMEDIATELY = Natives.Invoke("Void", 0xD220BDD222AC4A1E)
    },

    MONEY = {
        NETWORK_GET_VC_BANK_BALANCE   = Natives.Invoke("Int", 0x76EF28DA05EA395A),
        NETWORK_GET_VC_WALLET_BALANCE = Natives.Invoke("Int", 0xA40F9C2623F6A8B5)
    },

    NETSHOPPING = {
        NET_GAMESERVER_GET_PRICE               = Natives.Invoke("Int", 0xC27009422FCCA88D),
        NET_GAMESERVER_BASKET_IS_ACTIVE        = Natives.Invoke("Bool", 0xA65568121DF2EA26),
        NET_GAMESERVER_BASKET_END              = Natives.Invoke("Bool", 0xFA336E7F40C0A0D0),
        NET_GAMESERVER_TRANSFER_BANK_TO_WALLET = Natives.Invoke("Bool", 0xD47A2C1BA117471D),
        NET_GAMESERVER_TRANSFER_WALLET_TO_BANK = Natives.Invoke("Bool", 0xC2F7FE5309181C7D)
    },

    NETWORK = {
        NETWORK_GET_HOST_OF_SCRIPT = Natives.Invoke("Int", 0x1D6A14F1F9A736FC),
        NETWORK_IS_SESSION_STARTED = Natives.Invoke("Bool", 0x9DE624D2FC4B603F),
        NETWORK_IS_SESSION_ACTIVE  = Natives.Invoke("Bool", 0xD83C2B94E7508980),
        GET_ONLINE_VERSION         = Natives.Invoke("String", 0xFCA9373EF340AC0A)
    },

    PAD = {
        ENABLE_CONTROL_ACTION        = Natives.Invoke("Void", 0x351220255D64C155),
        SET_CONTROL_VALUE_NEXT_FRAME = Natives.Invoke("Bool", 0xE8A25867FBA3B05E),
        SET_CURSOR_POSITION          = Natives.Invoke("Bool", 0xFC695459D4D0E219)
    },

    PLAYER = {
        GET_NUMBER_OF_PLAYERS = Natives.Invoke("Int", 0x407C7F91DDB46C16)
    },

    SCRIPT = {
        REQUEST_SCRIPT                                          = Natives.Invoke("Void", 0x6EB5F71AA68F2E8E),
        SET_SCRIPT_AS_NO_LONGER_NEEDED                          = Natives.Invoke("Void", 0xC90D2DCACD56184C),
        GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH = Natives.Invoke("Int", 0x2C83A9DA6BFFC4F9),
        DOES_SCRIPT_EXIST                                       = Natives.Invoke("Bool", 0xFC04745FBE67C19A),
        HAS_SCRIPT_LOADED                                       = Natives.Invoke("Bool", 0xE6CC9F3BA0FB9EF1),
    },

    STATS = {
        GET_PACKED_STAT_INT_CODE  = Natives.Invoke("Int", 0x0BC900A6FE73770C),
        GET_PACKED_STAT_BOOL_CODE = Natives.Invoke("Bool", 0xDA7EBFC49AE3F1B0),
        SET_PACKED_STAT_INT_CODE  = Natives.Invoke("Void", 0x1581503AE529CD2E),
        SET_PACKED_STAT_BOOL_CODE = Natives.Invoke("Void", 0xDB8A58AEAA67CD07),
        STAT_INCREMENT            = Natives.Invoke("Void", 0x9B5A68C6489E9909)
    },

    SYSTEM = {
        START_NEW_SCRIPT = Natives.Invoke("Int", 0xE81651AD79516E48)
    },

    ENTITY = {
        FREEZE_ENTITY_POSITION      = Natives.Invoke("Void", 0xA2C8D0B4B3A1D4F4),
        SET_ENTITY_COORDS_NO_OFFSET = Natives.Invoke("Void", 0x239A3351AC1DA385),
        GET_ENTITY_COORDS           = Natives.Invoke("Bool", 0x3FEF770D40960D5A)
    }
}

--#endregion

--#region eScript

eScript = {
    Business = {
        Bunker = {
            Laptop = { name = "appbunkerbusiness", stack = 4592, hash = J("appbunkerbusiness") },
            Sell   = { name = "gb_gunrunning",     stack = 0,    hash = J("gb_gunrunning")     }
        },

        Hangar = {
            Laptop = { name = "appsmuggler", stack = 4592, hash = J("appsmuggler") },
            Sell   = { name = "gb_smuggler", stack = 0,    hash = J("gb_smuggler") }
        },

        Nightclub = { name = "appbusinesshub", stack = 4592, hash = J("appbusinesshub") },

        CrateWarehouse = {
            Laptop = { name = "appsecuroserv",      stack = 8344, hash = J("appsecuroserv")      },
            Sell   = { name = "gb_contraband_sell", stack = 0,    hash = J("gb_contraband_sell") }
        }
    },

    Heist = {
        Old           = { name = "fm_mission_controller",      stack = 0, hash = J("fm_mission_controller")      },
        New           = { name = "fm_mission_controller_2020", stack = 0, hash = J("fm_mission_controller_2020") },
        Agency        = { name = "fm_mission_controller_2020", stack = 0, hash = J("fm_mission_controller_2020") },
        Apartment     = { name = "fm_mission_controller",      stack = 0, hash = J("fm_mission_controller")      },
        AutoShop      = { name = "fm_mission_controller_2020", stack = 0, hash = J("fm_mission_controller_2020") },
        CayoPerico    = { name = "fm_mission_controller_2020", stack = 0, hash = J("fm_mission_controller_2020") },
        DiamondCasino = { name = "fm_mission_controller",      stack = 0, hash = J("fm_mission_controller")      },
        Doomsday      = { name = "fm_mission_controller",      stack = 0, hash = J("fm_mission_controller")      }
    },

    World = {
        Casino = {
            LuckyWheel = { name = "casino_lucky_wheel", stack = 0, hash = J("casino_lucky_wheel") },
            Slots      = { name = "casino_slots",       stack = 0, hash = J("casino_slots")       },
            Roulette   = { name = "casinoroulette",     stack = 0, hash = J("casinoroulette")     },
            Blackjack  = { name = "blackjack",          stack = 0, hash = J("blackjack")          },
            Poker      = { name = "three_card_poker",   stack = 0, hash = J("three_card_poker")   }
        }
    }
}

--#endregion

--#region Utils

function Utils.ClearTable(tbl)
    for i = #tbl, 1, -1 do
        table.remove(tbl, i)
    end
end

function Utils.FillDynamicTables()
    -- eTable.Heist.CayoPerico.Files
    Utils.ClearTable(eTable.Heist.CayoPerico.Files)

    if FileMgr.DoesFileExist(CAYO_DIR) then
        local files = FileMgr.FindFiles(CAYO_DIR, ".json", true)

        for i, file in ipairs(files) do
            local fileName = string.match(file, "[^\\]+$"):gsub(".json", "")
            I(eTable.Heist.CayoPerico.Files, { name = fileName, index = i })
        end
    end

    if #eTable.Heist.CayoPerico.Files == 0 then
        I(eTable.Heist.CayoPerico.Files, { name = "", index = -1 })
    end

    -- eTable.Heist.DiamondCasino.Files
    Utils.ClearTable(eTable.Heist.DiamondCasino.Files)

    if FileMgr.DoesFileExist(DIAMOND_DIR) then
        local files = FileMgr.FindFiles(DIAMOND_DIR, ".json", true)

        for i, file in ipairs(files) do
            local fileName = string.match(file, "[^\\]+$"):gsub(".json", "")
            I(eTable.Heist.DiamondCasino.Files, { name = fileName, index = i })
        end
    end

    if #eTable.Heist.DiamondCasino.Files == 0 then
        I(eTable.Heist.DiamondCasino.Files, { name = "", index = -1 })
    end

    -- eTable.Editor.Stats.Files
    Utils.ClearTable(eTable.Editor.Stats.Files)

    if FileMgr.DoesFileExist(STATS_DIR) then
        local files = FileMgr.FindFiles(STATS_DIR, ".json", true)

        for i, file in ipairs(files) do
            local fileName = string.match(file, "[^\\]+$"):gsub(".json", "")
            I(eTable.Editor.Stats.Files, { name = fileName, index = i })
        end
    end

    if #eTable.Editor.Stats.Files == 0 then
        I(eTable.Editor.Stats.Files, { name = "", index = -1 })
    end

    -- eTable.Business.Supplies
    Utils.ClearTable(eTable.Business.Supplies)

    local businesses = {
        { name = "Cash Factory",  ids = { 4,  9, 14, 19 } },
        { name = "Cocaine Lock.", ids = { 3,  8, 13, 18 } },
        { name = "Weed Farm",     ids = { 2,  7, 12, 17 } },
        { name = "Meth Lab",      ids = { 1,  6, 11, 16 } },
        { name = "Document For.", ids = { 5, 10, 15, 20 } }
    }

    for i = 0, 4 do
        local slot = eStat[F("MPX_FACTORYSLOT%d", i)]:Get()

        if slot > 0 then
            for _, business in ipairs(businesses) do
                for _, id in ipairs(business.ids) do
                    if slot == id then
                        I(eTable.Business.Supplies, { name = business.name, index = i })
                        break
                    end
                end
            end
        end
    end

    if eStat.MPX_FACTORYSLOT5:Get() > 0 then
        I(eTable.Business.Supplies, { name = "Bunker", index = 5 })
    end

    if eStat.MPX_XM22_LAB_OWNED:Get() ~= -1 and eStat.MPX_XM22_LAB_OWNED:Get() ~= 0 then
        I(eTable.Business.Supplies, { name = "Acid Lab", index = 6 })
    end

    if #eTable.Business.Supplies == 0 then
        I(eTable.Business.Supplies, { name = "None", index = -1 })
    else
        I(eTable.Business.Supplies, 1, { name = "All", index = 7 })
    end

    -- eTable.Settings.Languages
    Utils.ClearTable(eTable.Settings.Languages)

    I(eTable.Settings.Languages, { name = "EN", index = 0 })

    local langIndex = 1

    if FileMgr.DoesFileExist(TRANS_DIR) then
        local files = FileMgr.FindFiles(TRANS_DIR, ".json", true)

        for _, file in ipairs(files) do
            local fileName = string.match(file, "[^\\]+$"):gsub(".json", "")

            if fileName ~= "EN" then
                I(eTable.Settings.Languages, { name = fileName, index = langIndex })
                langIndex = langIndex + 1
            end
        end
    end
end

--#endregion

--#region Parser

Parser = {}

function Parser.ParseTunables(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and v.tunable then
            local hash = 0

            if type(v.tunable) == "string" then
                hash = J(v.tunable)
            elseif type(v.tunable) == "number" and v.tunable == math.floor(v.tunable) then
                hash = v.tunable
            else
                SilentLogger.LogError(F("Bad tunable! %s", S(v.tunable)))
                break
            end

            local ptr = ScriptGlobal.GetTunableByHash(hash)

            if ptr == 0 then
                SilentLogger.LogError(F("Bad tunable ptr! %s %s", S(v.tunable), S(ptr)))
                break
            end

            v.ptr = ptr

            v.Get = function(self)
                if self.type == "int" then
                    return Memory.ReadInt(self.ptr)
                elseif self.type == "float" then
                    return Memory.ReadFloat(self.ptr)
                end

                SilentLogger.LogError(F("No type for tunable! %s", S(self.tunable)))
                return nil
            end

            v.Set = function(self, value)
                if self.type == "int" then
                    Memory.WriteInt(self.ptr, value)
                elseif self.type == "float" then
                    Memory.WriteFloat(self.ptr, value)
                else
                    SilentLogger.LogError(F("No type for tunable! %s", S(self.tunable)))
                end
            end

            v.Reset = function(self)
                if self.type == "int" then
                    Memory.WriteInt(self.ptr, self.defaultValue)
                elseif self.type == "float" then
                    Memory.WriteFloat(self.ptr, self.defaultValue)
                else
                    SilentLogger.LogError(F("No type for tunable! %s", S(self.tunable)))
                end
            end
        elseif type(v) == "table" then
            Parser.ParseTunables(v)
        end
    end

    tbl.HAS_PARSED = true
end

function Parser.ParseGlobals(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and v.global then
            v.Get = function(self)
                if self.type == "int" then
                    return ScriptGlobal.GetInt(self.global)
                elseif self.type == "float" then
                    return ScriptGlobal.GetFloat(self.global)
                elseif self.type == "bool" then
                    return ScriptGlobal.GetBool(self.global)
                end
                SilentLogger.LogError(F("No type for global! %s", S(self.global)))
                return nil
            end

            v.Set = function(self, value)
                if self.type == "int" then
                    ScriptGlobal.SetInt(self.global, value)
                elseif self.type == "float" then
                    ScriptGlobal.SetFloat(self.global, value)
                elseif self.type == "bool" then
                    ScriptGlobal.SetBool(self.global, value)
                else
                    SilentLogger.LogError(F("No type for global! %s", S(self.global)))
                end
            end
        elseif type(v) == "table" then
            Parser.ParseGlobals(v)
        end
    end

    tbl.HAS_PARSED = true
end

function Parser.ParseLocals(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and v.vLocal then
            v.Get = function(self)
                local hash = J(self.script)

                if self.type == "int" then
                    return ScriptLocal.GetInt(hash, self.vLocal)
                elseif self.type == "float" then
                    return ScriptLocal.GetFloat(hash, self.vLocal)
                end

                SilentLogger.LogError(F("No type for local! %s", S(self.vLocal)))
                return nil
            end

            v.Set = function(self, value)
                local hash = J(self.script)

                if self.type == "int" then
                    ScriptLocal.SetInt(hash, self.vLocal, value)
                elseif self.type == "float" then
                    ScriptLocal.SetFloat(hash, self.vLocal, value)
                else
                    SilentLogger.LogError(F("No type for local! %s", S(self.vLocal)))
                end
            end
        elseif type(v) == "table" then
            Parser.ParseLocals(v)
        end
    end

    tbl.HAS_PARSED = true
end

function Parser.ParseStats(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and v.stat then
            local function IsStoryStat()
                return v.stat:find("SP0") or v.stat:find("SP1") or v.stat:find("SP2")
            end

            local hash = 0

            if not v.stat:find("MPPLY") and not IsStoryStat() then
                local _, charSlot = Stats.GetInt(J("MPPLY_LAST_MP_CHAR"))
                hash = J(F("MP%d_%s", charSlot, v.stat))
            elseif v.stat:find("MPPLY") or IsStoryStat() then
                hash = J(v.stat)
            else
                SilentLogger.LogError(F("Bad stat! %s", S(v.stat)))
                break
            end

            v.hash = hash

            v.Get = function(self)
                if self.type == "int" then
                    local _, value = Stats.GetInt(self.hash)
                    return value
                elseif self.type == "float" then
                    local _, value = Stats.GetFloat(self.hash)
                    return value
                elseif self.type == "bool" then
                    local _, value = Stats.GetBool(self.hash)
                    return value
                end

                SilentLogger.LogError(F("No type for stat! %s", S(self.stat)))
                return nil
            end

            v.Set = function(self, value)
                if self.type == "int" then
                    Stats.SetInt(self.hash, value)
                elseif self.type == "float" then
                    Stats.SetFloat(self.hash, value)
                elseif self.type == "bool" then
                    Stats.SetBool(self.hash, value)
                else
                    SilentLogger.LogError(F("No type for stat! %s", S(self.stat)))
                end
            end
        elseif type(v) == "table" then
            Parser.ParseStats(v)
        end
    end

    tbl.HAS_PARSED = true
end

function Parser.ParsePackedBools(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and v[1] then
            v.Set = function(self, value)
                local _, charSlot = Stats.GetInt(J("MPPLY_LAST_MP_CHAR"))

                if v[2] then
                    for i = v[1], v[2] do
                        eNative.STATS.SET_PACKED_STAT_BOOL_CODE(i, value, charSlot)
                    end
                else
                    eNative.STATS.SET_PACKED_STAT_BOOL_CODE(v[1], value, charSlot)
                end
            end
        elseif type(v) == "table" then
            Parser.ParsePackedBools(v)
        end
    end

    tbl.HAS_PARSED = true
end

function Parser.ParseTables(tbl)
    for _, v in pairs(tbl) do
        if type(v) == "table" and #v > 0 and type(v[1]) == "table" then
            v.GetName = function(self, index)
                for _, item in ipairs(v) do
                    if item.index == index then
                        return item.name
                    end
                end
            end

            v.GetNames = function(self)
                local names = {}

                for _, item in ipairs(v) do
                    I(names, item.name)
                end

                return names
            end

            v.GetNamesRange = function(self, start, finish)
                local names = {}

                for i = start, finish do
                    if v[i] then
                        I(names, v[i].name)
                    end
                end

                return names
            end

            v.GetIndex = function(self, name)
                for _, item in ipairs(v) do
                    if item.name:lower() == name:lower() then
                        return item.index
                    end
                end
            end

            v.GetIndexes = function(self)
                local indexes = {}

                for _, item in ipairs(v) do
                    I(indexes, item.index)
                end

                return indexes
            end
        elseif type(v) == "table" then
            Parser.ParseTables(v)
        end
    end

    tbl.HAS_PARSED = true
end

Parser.ParseTunables(eTunable)
Parser.ParseGlobals(eGlobal)
Parser.ParseLocals(eLocal)
Parser.ParseStats(eStat)
Parser.ParsePackedBools(ePackedBool)
Utils.FillDynamicTables()
Parser.ParseTables(eTable)

Script.QueueJob(function()
    while not eTunable.HAS_PARSED and eGlobal.HAS_PARSED and eLocal.HAS_PARSED and eStat.HAS_PARSED and ePackedBool.HAS_PARSED and eTable.HAS_PARSED do
        Script.Yield()
    end

    SilentLogger.LogInfo(F("%s has started ツ", SCRIPT_NAME))
end)

--#endregion

--#region Helper

Helper = {}

function Helper.SetBit(value, position)
    return value | (1 << position)
end

function Helper.NewInstantFinishHeist()
    if GTA.IsScriptRunning(eScript.Heist.Old) then
        GTA.ForceScriptHost(eScript.Heist.Old)
        Script.Yield(1000)

        eLocal.Heist.Generic.Finish.Old.Step1:Set(5)
        eLocal.Heist.Generic.Finish.Old.Step2:Set(999999)

        local value = eLocal.Heist.Generic.Finish.Old.Step3:Get()
        value = Helper.SetBit(value, 9)
        value = Helper.SetBit(value, 16)

        eLocal.Heist.Generic.Finish.Old.Step3:Set(value)
    elseif GTA.IsScriptRunning(eScript.Heist.New) then
        GTA.ForceScriptHost(eScript.Heist.New)
        Script.Yield(1000)

        eLocal.Heist.Generic.Finish.New.Step1:Set(5)
        eLocal.Heist.Generic.Finish.New.Step2:Set(999999)

        local value = eLocal.Heist.Generic.Finish.New.Step3:Get()
        value = Helper.SetBit(value, 9)
        value = Helper.SetBit(value, 16)

        eLocal.Heist.Generic.Finish.New.Step3:Set(value)
    end
end

function Helper.SetApartmentMaxPayout(bool)
    local ftr  = eFeature.Heist.Apartment.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local heist      = eGlobal.Heist.Apartment.Heist.Type:Get()
    local difficulty = eGlobal.Heist.Apartment.Heist.Difficulty:Get() + 1

    local payouts = {
        [eTable.Heist.Apartment.Heists.FleecaJob]   = { 100625, 201250,  251562  },
        [eTable.Heist.Apartment.Heists.PrisonBreak] = { 350000, 700000,  875000  },
        [eTable.Heist.Apartment.Heists.HumaneLabs]  = { 472500, 945000,  1181250 },
        [eTable.Heist.Apartment.Heists.SeriesA]     = { 353500, 707000,  883750  },
        [eTable.Heist.Apartment.Heists.PacificJob]  = { 750000, 1500000, 1875000 }
    }

    if payouts[heist] == nil then return end

    local payout    = payouts[heist][difficulty]
    local maxPayout = 3000000
    local cut       = math.floor(maxPayout / (payout / 100) / ((bool) and 2 or 1))

    for i = 1, team do
        FeatureMgr.GetFeature(apartmentPlayers[i]):SetIntValue(cut)
    end
end

function Helper.SetCayoMaxPayout()
    local ftr  = eFeature.Heist.CayoPerico.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local target     = eStat.MPX_H4CNF_TARGET:Get()
    local difficulty = (eStat.MPX_H4_PROGRESS:Get() == eTable.Heist.CayoPerico.Difficulties[2].index) and 2 or 1

    local payouts = {
        [0] = { 630000,  693000  },
        [1] = { 700000,  770000  },
        [2] = { 770000,  847000  },
        [3] = { 1300000, 1430000 },
        [4] = { 1100000, 1210000 },
        [5] = { 1900000, 2090000 }
    }

    if payouts[target] == nil then return end

    local payout      = payouts[target][difficulty]
    local maxPayout   = 2550000
    local cut         = math.floor(maxPayout / (payout / 100))
    local finalPayout = math.floor(payout * (cut / 100))
    local difference  = 1000
    local pavelCut    = 0.02
    local fencingCut  = 0.1
    local foundCut    = false

    while not foundCut do
        local pavelFee   = math.floor(finalPayout * pavelCut)
        local fencingFee = math.floor(finalPayout * fencingCut)
        local feePayout  = finalPayout - (pavelFee + fencingFee)

        if feePayout >= maxPayout - difference and feePayout <= maxPayout then
            foundCut = true
        else
            cut = cut + 1
            finalPayout = math.floor(payout * (cut / 100))

            if cut > 500 then
                cut         = math.floor(maxPayout / (payout / 100))
                finalPayout = math.floor(payout * (cut / 100))
                difference  = difference + 1000
            end
        end
    end

    for i = 1, team do
        FeatureMgr.GetFeature(cayoPlayers[i]):SetIntValue(cut)
    end
end

function Helper.SetDiamondMaxPayout()
    eTunable.Heist.DiamondCasino.Buyer.Low:Set(1.0)
    eTunable.Heist.DiamondCasino.Buyer.Mid:Set(1.0)
    eTunable.Heist.DiamondCasino.Buyer.High:Set(1.0)

    local ftr  = eFeature.Heist.DiamondCasino.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local difficulty = (eStat.MPX_H3OPT_APPROACH:Get() == eStat.MPX_H3_HARD_APPROACH:Get()) and 2 or 1
    local target     = eStat.MPX_H3OPT_TARGET:Get()

    local payouts = {
        [0] = { 2115000, 2326500 },
        [2] = { 2350000, 2585000 },
        [1] = { 2585000, 2843500 },
        [3] = { 3290000, 3619000 }
    }

    if payouts[target] == nil then return end

    local payout    = payouts[target][difficulty] + 819000
    local maxPayout = 3619000
    local cut       = math.floor(maxPayout / (payout / 100))

    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Cuts.Player1):SetIntValue(cut)

    if team > 1 then
        local gunman     = eStat.MPX_H3OPT_CREWWEAP:Get()
        local driver     = eStat.MPX_H3OPT_CREWDRIVER:Get()
        local hacker     = eStat.MPX_H3OPT_CREWHACKER:Get()
        local buyerFee   = 0.1
        local lesterCut  = 0.05

        local gunmanCuts = {
            [1] = 0.05,
            [3] = 0.07,
            [5] = 0.08,
            [2] = 0.09,
            [4] = 0.1
        }

        local driverCuts = {
            [1] = 0.05,
            [4] = 0.06,
            [2] = 0.07,
            [3] = 0.09,
            [5] = 0.1
        }

        local hackerCuts = {
            [1] = 0.03,
            [3] = 0.05,
            [2] = 0.07,
            [5] = 0.09,
            [4] = 0.1
        }

        local feePayout = payout - (payout * buyerFee)
        local lesterCut = feePayout * lesterCut
        local gunmanCut = feePayout * gunmanCuts[gunman]
        local driverCut = feePayout * driverCuts[driver]
        local hackerCut = feePayout * hackerCuts[hacker]
        local crewCut   = lesterCut + gunmanCut + driverCut + hackerCut
        local cut       = math.floor(maxPayout / ((feePayout - crewCut) / 100))

        for i = 2, team do
            FeatureMgr.GetFeature(diamondPlayers[i]):SetIntValue(cut)
        end
    end
end

function Helper.SetDoomsdayMaxPayout(bool)
    local ftr  = eFeature.Heist.Doomsday.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local heist      = eStat.MPX_GANGOPS_FLOW_MISSION_PROG:Get()
    local difficulty = eGlobal.Heist.Apartment.Heist.Difficulty:Get()

    local payouts = {
        [eTable.Heist.Doomsday.Heists.Data]     = { 975000,  1218750 },
        [eTable.Heist.Doomsday.Heists.Bogdan]   = { 1425000, 1771250 },
        [eTable.Heist.Doomsday.Heists.Doomsday] = { 1800000, 2250000 }
    }

    if payouts[heist] == nil then return end
    if difficulty == 0 then difficulty = 1 end

    local payout    = payouts[heist][difficulty]
    local maxPayout = 2550000
    local cut       = math.floor(maxPayout / (payout / 100))

    for i = 1, team do
        FeatureMgr.GetFeature(doomsdayPlayers[i]):SetIntValue(cut)
    end
end

function Helper.ApplyCayoPreset(preps)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Difficulty):SetListIndex(preps.difficulty or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Approach):SetListIndex(preps.approach or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Loadout):SetListIndex(preps.loadout or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Primary):SetListIndex(preps.primary_target or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Compound):SetListIndex(preps.compound_target or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Compound):SetListIndex(preps.compound_amount or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Arts):SetListIndex(preps.arts_amount or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Island):SetListIndex(preps.island_target or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Island):SetListIndex(preps.island_amount or 0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Advanced):Toggle(preps.advanced or false)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Cash):SetIntValue(preps.cash_value or 83250)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Weed):SetIntValue(preps.weed_value or 135000)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Coke):SetIntValue(preps.coke_value or 202500)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Gold):SetIntValue(preps.gold_value or 333333)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Arts):SetIntValue(preps.arts_value or 180000)
end

function Helper.ApplyDiamondPreset(preps)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Difficulty):SetListIndex(preps.difficulty or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Approach):SetListIndex(preps.approach or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Gunman):SetListIndex(preps.gunman or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Loadout):SetListIndex(preps.loadout or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Driver):SetListIndex(preps.driver or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Vehicles):SetListIndex(preps.vehicles or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Hacker):SetListIndex(preps.hacker or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Masks):SetListIndex(preps.masks or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Guards):SetListIndex(preps.guards or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Keycards):SetListIndex(preps.keycards or 0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Target):SetListIndex(preps.target or 0)
end

function Helper.RefreshFiles()
    Utils.FillDynamicTables()
    Parser.ParseTables(eTable)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Presets.File):SetList(eFeature.Heist.CayoPerico.Presets.File.list:GetNames()):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Presets.Name):SetStringValue(eFeature.Heist.CayoPerico.Presets.File.list[1].name)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Presets.File):SetList(eFeature.Heist.DiamondCasino.Presets.File.list:GetNames()):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Presets.Name):SetStringValue(eFeature.Heist.DiamondCasino.Presets.File.list[1].name)
    FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.File):SetList(eFeature.Dev.Editor.Stats.File.list:GetNames()):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Settings.Translation.File):SetList(eFeature.Settings.Translation.File.list:GetNames()):SetListIndex(0)
end

function Helper.GetCardName(index)
	if index == 0 then
		return "Rolling..."
	end

	local number = math.fmod(index, 13)
	local name   = ""
	local suit   = ""

	if number == 1 then
		name = "A"
	elseif number == 0 then
		name = "K"
	elseif number == 12 then
		name = "Q"
	elseif number == 11 then
		name = "J"
	else
		name = S(number)
	end

	if index >= 1 and index <= 13 then
		suit = "Clubs"
	elseif index >= 14 and index <= 26 then
		suit = "Diam."
	elseif index >= 27 and index <= 39 then
		suit = "Hearts"
	elseif index >= 40 and index <= 52 then
		suit = "Spades"
	end

	return name .. " " .. suit
end

function Helper.GetPokerPlayersCount()
    local currentTable = eLocal.World.Casino.Poker.CurrentTable:Get()
    local table        = eLocal.World.Casino.Poker.Table.vLocal
    local tableSize    = eLocal.World.Casino.Poker.TableSize.vLocal
    local players      = 0

	for i = 0, 31 do
		local playersTable = ScriptLocal.GetInt(eScript.World.Casino.Poker.hash, table + 1 + (i * tableSize) + 2)

		if PLAYER_ID ~= i and playersTable == currentTable then
			players = players + 1
		end
	end

    return players
end

function Helper.GetPokerCards(id)
    local currentTable  = eLocal.World.Casino.Poker.CurrentTable:Get()
    local cards         = eLocal.World.Casino.Poker.Cards.vLocal
    local currentDeck   = eLocal.World.Casino.Poker.CurrentDeck.vLocal
    local antiCheat     = eLocal.World.Casino.Poker.AntiCheat.vLocal
    local antiCheatDeck = eLocal.World.Casino.Poker.AntiCheatDeck.vLocal
    local deckSize      = eLocal.World.Casino.Poker.DeckSize.vLocal
    local card1         = ScriptLocal.GetInt(eScript.World.Casino.Poker.hash, cards + currentDeck + 1 + (currentTable * deckSize) + 2 + 1 + (id * 3))
	local card2         = ScriptLocal.GetInt(eScript.World.Casino.Poker.hash, cards + currentDeck + 1 + (currentTable * deckSize) + 2 + 2 + (id * 3))
	local card3         = ScriptLocal.GetInt(eScript.World.Casino.Poker.hash, cards + currentDeck + 1 + (currentTable * deckSize) + 2 + 3 + (id * 3))
    return Helper.GetCardName(card1) .. ", " .. Helper.GetCardName(card2) .. ", " .. Helper.GetCardName(card3)
end

function Helper.SetPokerCards(id, card1, card2, card3)
    local currentTable  = eLocal.World.Casino.Poker.CurrentTable:Get()
    local cards         = eLocal.World.Casino.Poker.Cards.vLocal
    local currentDeck   = eLocal.World.Casino.Poker.CurrentDeck.vLocal
    local antiCheat     = eLocal.World.Casino.Poker.AntiCheat.vLocal
    local antiCheatDeck = eLocal.World.Casino.Poker.AntiCheatDeck.vLocal
    local deckSize      = eLocal.World.Casino.Poker.DeckSize.vLocal
	ScriptLocal.SetInt(eScript.World.Casino.Poker.hash, cards + currentDeck + 1 + (currentTable * deckSize) + 2 + 1 + (id * 3), card1)
	ScriptLocal.SetInt(eScript.World.Casino.Poker.hash, cards + currentDeck + 1 + (currentTable * deckSize) + 2 + 2 + (id * 3), card2)
	ScriptLocal.SetInt(eScript.World.Casino.Poker.hash, cards + currentDeck + 1 + (currentTable * deckSize) + 2 + 3 + (id * 3), card3)
	ScriptLocal.SetInt(eScript.World.Casino.Poker.hash, antiCheat + antiCheatDeck + 1 + 1 + (currentTable * deckSize) + 1 + (id * 3), card1)
	ScriptLocal.SetInt(eScript.World.Casino.Poker.hash, antiCheat + antiCheatDeck + 1 + 1 + (currentTable * deckSize) + 2 + (id * 3), card2)
	ScriptLocal.SetInt(eScript.World.Casino.Poker.hash, antiCheat + antiCheatDeck + 1 + 1 + (currentTable * deckSize) + 3 + (id * 3), card3)
end

--#endregion

--#region eFeature

eFeature = {
    Heist = {
        Generic = {
            Launch = {
                hash = J("SN_Generic_Launch"),
                name = "Solo Launch",
                type = eFeatureType.Toggle,
                desc = "Allows launching the heist alone.",
                func = function(ftr)
                    if GTA.IsInSession() then
                        if ftr:IsToggled() then
                            eLocal.Heist.Generic.Launch.Step1:Set(1)
                            ScriptGlobal.SetInt(794954 + 4 + 1 + (eLocal.Heist.Generic.Launch.Step2:Get() * 95) + 75, 1)
                            eGlobal.Heist.Generic.Launch.Step1:Set(1)
                            eGlobal.Heist.Generic.Launch.Step2:Set(1)
                            eGlobal.Heist.Generic.Launch.Step3:Set(1)
                            eGlobal.Heist.Generic.Launch.Step4:Set(0)

                            if not loggedSoloLaunch then
                                SilentLogger.LogInfo("[Solo Launch] Heists should've been made launchable ツ")
                                loggedSoloLaunch = true
                            end
                        else
                            SilentLogger.LogInfo("[Solo Launch] Heists should've been made unlaunchable ツ")
                            loggedSoloLaunch = false
                        end
                    end
                end
            },

            Cutscene = {
                hash = J("SN_Generic_Cutscene"),
                name = "Skip Cutscene",
                type = eFeatureType.Button,
                desc = "Skips the current cutscene.",
                func = function()
                    eNative.CUTSCENE.STOP_CUTSCENE_IMMEDIATELY()
                    SilentLogger.LogInfo("[Skip Cutscene] Cutscene should've been skipped ツ")
                end
            },

            Skip = {
                hash = J("SN_Generic_Skip"),
                name = "Skip Checkpoint",
                type = eFeatureType.Button,
                desc = "Skips the heist to the next checkpoint.",
                func = function()
                    eLocal.Heist.Generic.Skip.Old:Set(eLocal.Heist.Generic.Skip.Old:Get() | (1 << 17))
                    eLocal.Heist.Generic.Skip.New:Set(eLocal.Heist.Generic.Skip.New:Get() | (1 << 17))
                    SilentLogger.LogInfo("[Skip Checkpoint] Checkpoint should've been skipped ツ")
                end
            },

            Cut = {
                hash = J("SN_Generic_Cut"),
                name = "Self",
                type = eFeatureType.InputInt,
                desc = "Select the cut for yourself.",
                defv = 0,
                lims = { 0, 999 },
                step = 1,
                func = function(ftr)
                    SilentLogger.LogInfo("[Self] Self cut should've been changed. Don't forget to apply ツ")
                end
            },

            Apply = {
                hash = J("SN_Generic_Apply"),
                name = "Apply Cut",
                type = eFeatureType.Button,
                desc = "Applies the selected cut for yourself.",
                func = function(cut)
                    eGlobal.Heist.Generic.Cut:Set(cut)
                    SilentLogger.LogInfo("[Apply Cut] Cut should've been applied ツ")
                end
            }
        },

        Agency = {
            Preps = {
                Contract = {
                    hash = J("SN_Agency_Contract"),
                    name = "Contract",
                    type = eFeatureType.Combo,
                    desc = "Select the desired VIP contract.",
                    list = eTable.Heist.Agency.Contracts,
                    func = function(ftr)
                        local list  = eTable.Heist.Agency.Contracts
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Contract (Agency)] Selected contract: %s ツ", list:GetName(index)))
                    end
                },

                Complete = {
                    hash = J("SN_Agency_Complete"),
                    name = "Apply & Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Applies all changes and completes all preparations.",
                    func = function(contract)
                        eStat.MPX_FIXER_STORY_BS:Set(contract)

                        if contract < 18 then
                            eStat.MPX_FIXER_STORY_STRAND:Set(0)
                        elseif contract < 128 then
                            eStat.MPX_FIXER_STORY_STRAND:Set(1)
                        elseif contract < 2044 then
                            eStat.MPX_FIXER_STORY_STRAND:Set(2)
                        else
                            eStat.MPX_FIXER_STORY_STRAND:Set(-1)
                        end

                        eStat.MPX_FIXER_GENERAL_BS:Set(-1)
                        eStat.MPX_FIXER_COMPLETED_BS:Set(-1)

                        SilentLogger.LogInfo("[Apply & Complete Preps (Agency)] Preps should've been completed ツ")
                    end
                }
            },

            Misc = {
                Finish = {
                    hash = Utils.Joaat("SN_Agency_Finish"),
                    name = "Instant Finish",
                    type = eFeatureType.Button,
                    desc = "Finishes the heist instantly. Use after you can see the minimap.",
                    func = function()
                        if CONFIG.instant_finish.agency == 1 then
                            Helper.NewInstantFinishHeist()

                            SilentLogger.LogInfo("[Instant Finish] Heist should've been finished. Method used: New ツ")
                            return
                        end

                        GTA.ForceScriptHost(eScript.Heist.Agency)
                        Script.Yield(1000)
                        eLocal.Heist.Agency.Finish.Step1:Set(51338752)
                        eLocal.Heist.Agency.Finish.Step2:Set(50)

                        SilentLogger.LogInfo("[Instant Finish (Agency)] Heist should've been finished. Method used: Old ツ")
                    end
                },

                Cooldown = {
                    hash = J("SN_Agency_Cooldown"),
                    name = "Kill Cooldowns",
                    type = eFeatureType.Button,
                    desc = "Skips the heist's cooldowns. Doesn't skip the cooldown between transactions (20 min).",
                    func = function()
                        eTunable.Heist.Agency.Cooldown.Story:Set(0)
                        eTunable.Heist.Agency.Cooldown.Security:Set(0)
                        eTunable.Heist.Agency.Cooldown.Payphone:Set(0)
                        SilentLogger.LogInfo("[Kill Cooldowns (Agency)] Cooldowns should've been killed ツ")
                    end
                }
            },

            Payout = {
                Select = {
                    hash = J("SN_Agency_Select"),
                    name = "Payout",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired payout.",
                    defv = 0,
                    lims = { 0, 2500000 },
                    step = 100000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Payout (Agency)] Payout should've been changed. Don't forget to apply ツ")
                    end
                },

                Max = {
                    hash = J("SN_Agency_Max"),
                    name = "Max",
                    type = eFeatureType.Button,
                    desc = "Maximizes the payout, but doesn't apply it.",
                    func = function()
                        SilentLogger.LogInfo("[Max (Agency)] Payout should've been maximized. Don't forget to apply ツ")
                    end
                },

                Apply = {
                    hash = J("SN_Agency_Apply"),
                    name = "Apply Payout",
                    type = eFeatureType.Button,
                    desc = "Applies the selected payout. Use after you can see the minimap.",
                    func = function(payout)
                        eTunable.Heist.Agency.Payout:Set(payout)
                        SilentLogger.LogInfo("[Apply Payout (Agency)] Payout should've been applied ツ")
                    end
                }
            }
        },

        Apartment = {
            Preps = {
                Complete = {
                    hash = J("SN_Apartment_Complete"),
                    name = "Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Completes all preparations.",
                    func = function()
                        eStat.MPX_HEIST_PLANNING_STAGE:Set(-1)

                        if CONFIG.collab.jinxscript.enabled then
                            Script.LoadSubscribedScript("JinxScript EE & LE")

                            if FeatureMgr.GetFeatureByHash(eTable.JinxScript.Features.RestartFreemode) then
                                SilentLogger.LogInfo("[JinxScript EE & LE (Settings)] Restarting freemode using JinxScript ツ")
                                FeatureMgr.GetFeatureByHash(eTable.JinxScript.Features.RestartFreemode):OnClick()
                                SilentLogger.LogInfo("[JinxScript EE & LE (Settings)] Freemode should've been restarted by JinxScript ツ")
                            else
                                SilentLogger.LogError("[JinxScript EE & LE (Settings)] JinxScript collab is enabled, but the script isn't running ツ")
                            end

                            if CONFIG.collab.jinxscript.autostop then
                                Script.LoadSubscribedScript("JinxScript EE & LE", true)
                            end
                        end

                        SilentLogger.LogInfo("[Complete Preps (Apartment)] Preps should've been completed ツ")
                    end
                },

                Reload = {
                    hash = J("SN_Apartment_Reload"),
                    name = "Redraw Board",
                    type = eFeatureType.Button,
                    desc = "Redraws the planning board.",
                    func = function()
                        eGlobal.Heist.Apartment.Reload:Set(22)
                        SilentLogger.LogInfo("[Redraw Board (Apartment)] Board should've been redrawn ツ")
                    end
                },

                Change = {
                    hash = J("SN_Apartment_Change"),
                    name = "Change Session",
                    type = eFeatureType.Button,
                    desc = "Changes your session to the new one.",
                    func = function()
                        GTA.StartSession(eTable.Session.Types.NewPublic)
                        SilentLogger.LogInfo("[Change Session (Apartment)] Online session should've been changed ツ")
                    end
                }
            },

            Misc = {
                Force = {
                    hash = J("SN_Apartment_Force"),
                    name = "Force Ready",
                    type = eFeatureType.Button,
                    desc = "Forces everyone to be «Ready».",
                    func = function()
                        GTA.ForceScriptHost(eScript.Heist.Apartment)
                        Script.Yield(1000)

                        for i = 2, 4 do
                            eGlobal.Heist.Apartment.Ready[F("Player%d", i)]:Set(6)
                        end

                        SilentLogger.LogInfo("[Force Ready (Apartment)] Everyone should've been forced ready ツ")
                    end
                },

                Finish = {
                    hash = J("SN_Apartment_Finish"),
                    name = "Instant Finish",
                    type = eFeatureType.Button,
                    desc = "Finishes the heist instantly. Use after you can see the minimap.",
                    func = function()
                        if CONFIG.instant_finish.apartment == 1 then
                            Helper.NewInstantFinishHeist()

                            SilentLogger.LogInfo("[Instant Finish (Apartment)] Heist should've been finished. Method used: New ツ")
                            return
                        end

                        GTA.ForceScriptHost(eScript.Heist.Apartment)
                        Script.Yield(1000)

                        local heist = eGlobal.Heist.Apartment.Heist.Type:Get()

                        if heist == eTable.Heist.Apartment.Heists.PacificJob then
                            eLocal.Heist.Apartment.Finish.Step2:Set(5)
                            eLocal.Heist.Apartment.Finish.Step3:Set(80)
                            eLocal.Heist.Apartment.Finish.Step4:Set(10000000)
                            eLocal.Heist.Apartment.Finish.Step5:Set(99999)
                            eLocal.Heist.Apartment.Finish.Step6:Set(99999)
                        else
                            eLocal.Heist.Apartment.Finish.Step1:Set(12)
                            eLocal.Heist.Apartment.Finish.Step4:Set(99999)
                            eLocal.Heist.Apartment.Finish.Step5:Set(99999)
                            eLocal.Heist.Apartment.Finish.Step6:Set(99999)
                        end

                        SilentLogger.LogInfo("[Instant Finish (Apartment)] Heist should've been finished. Method used: Old ツ")
                    end
                },

                FleecaHack = {
                    hash = J("SN_Apartment_FleecaHack"),
                    name = "Bypass Fleeca Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the hacking process of The Fleeca Job heist.",
                    func = function()
                        eLocal.Heist.Apartment.Bypass.Fleeca.Hack:Set(7)
                        SilentLogger.LogInfo("[Bypass Fleeca Hack (Apartment)] Hacking process should've been skipped ツ")
                    end
                },

                FleecaDrill = {
                    hash = J("SN_Apartment_FleecaDrill"),
                    name = "Bypass Fleeca Drill",
                    type = eFeatureType.Button,
                    desc = "Skips the drilling process of The Fleeca Job.",
                    func = function()
                        eLocal.Heist.Apartment.Bypass.Fleeca.Drill:Set(100)
                        SilentLogger.LogInfo("[Bypass Fleeca Drill (Apartment)] Drilling process should've been skipped ツ")
                    end
                },

                PacificHack = {
                    hash = J("SN_Apartment_PacificHack"),
                    name = "Bypass Pacific Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the hacking process of The Pacific Standard Job heist.",
                    func = function()
                        eLocal.Heist.Apartment.Bypass.Pacific.Hack:Set(9)
                        SilentLogger.LogInfo("[Bypass Pacific Hack (Apartment)] Hacking process should've been skipped ツ")
                    end
                },

                Cooldown = {
                    hash = J("SN_Apartment_Cooldown"),
                    name = "Kill Cooldown",
                    type = eFeatureType.Button,
                    desc = "Skips the heist's cooldown. Doesn't skip the cooldown between transactions (20 min).",
                    func = function()
                        eGlobal.Heist.Apartment.Cooldown:Set(-1)
                        SilentLogger.LogInfo("[Kill Cooldown (Apartment)] Cooldown should've been killed ツ")
                    end
                },

                Play = {
                    hash = J("SN_Apartment_Play"),
                    name = "Play Unavailable Jobs",
                    type = eFeatureType.Button,
                    desc = "Allows you to play unavailable jobs temporarily.",
                    func = function()
                        eGlobal.Heist.Apartment.Cooldown:Set(-1)
                        SilentLogger.LogInfo("[Play Unavailable Jobs (Apartment)] Unavailable jobs should've been made playable ツ")
                    end
                },

                Unlock = {
                    hash = J("SN_Apartment_Unlock"),
                    name = "Unlock All Jobs",
                    type = eFeatureType.Button,
                    desc = "Unlocks all jobs without playing every heist one by one. Restart the game to apply.",
                    func = function()
                        eStat.MPX_HEIST_SAVED_STRAND_0:Set(eTunable.Heist.Apartment.RootIdHash.Fleeca:Get())
                        eStat.MPX_HEIST_SAVED_STRAND_0_L:Set(5)
                        eStat.MPX_HEIST_SAVED_STRAND_1:Set(eTunable.Heist.Apartment.RootIdHash.Prison:Get())
                        eStat.MPX_HEIST_SAVED_STRAND_1_L:Set(5)
                        eStat.MPX_HEIST_SAVED_STRAND_2:Set(eTunable.Heist.Apartment.RootIdHash.Humane:Get())
                        eStat.MPX_HEIST_SAVED_STRAND_2_L:Set(5)
                        eStat.MPX_HEIST_SAVED_STRAND_3:Set(eTunable.Heist.Apartment.RootIdHash.Series:Get())
                        eStat.MPX_HEIST_SAVED_STRAND_3_L:Set(5)
                        eStat.MPX_HEIST_SAVED_STRAND_4:Set(eTunable.Heist.Apartment.RootIdHash.Pacific:Get())
                        eStat.MPX_HEIST_SAVED_STRAND_4_L:Set(5)

                        SilentLogger.LogInfo("[Unlock All Jobs (Apartment)] All jobs should've been unlocked. Don't forget to restart the game ツ")
                    end
                }
            },

            Cuts = {
                Team = {
                    hash = J("SN_Apartment_Team"),
                    name = "Team",
                    type = eFeatureType.Combo,
                    desc = "Select your number of players.",
                    list = eTable.Heist.Apartment.Team,
                    func = function(ftr)
                        local list  = eTable.Heist.Apartment.Team
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Team (Apartment)] Selected team size: %s ツ", list:GetName(index)))
                    end
                },

                Receivers = {
                    hash = J("SN_Apartment_Receivers"),
                    name = "Receivers",
                    type = eFeatureType.Combo,
                    desc = "Decide who will receive the money.",
                    list = eTable.Heist.Apartment.Receivers,
                    func = function(ftr)
                        local list  = eTable.Heist.Apartment.Receivers
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Receivers (Apartment)] Selected payout receivers: %s ツ", list:GetName(index)))
                    end
                },

                Presets = {
                    hash = J("SN_Apartment_Presets"),
                    name = "Presets",
                    type = eFeatureType.Combo,
                    desc = "Select one of the ready-made presets.",
                    list = eTable.Heist.Apartment.Presets,
                    func = function(bool)
                        Helper.SetApartmentMaxPayout(bool)
                    end
                },

                Bonus = {
                    hash = J("SN_Apartment_Bonus"),
                    name = "12mil Bonus",
                    type = eFeatureType.Toggle,
                    desc = "Allows only you to get 12 millions bonus for The Pacific Standard Job on hard difficulty, even if you're not the host. Enable before starting the heist. Has a cooldown of about 1 hour.",
                    func = function(ftr)
                        eStat.MPPLY_HEISTFLOWORDERPROGRESS:Set((ftr:IsToggled()) and 268435455 or 134217727)
                        eStat.MPPLY_AWD_HST_ORDER:Set((ftr:IsToggled()) and true or false)
                        eStat.MPPLY_HEISTTEAMPROGRESSBITSET:Set((ftr:IsToggled()) and 268435455 or 134217727)
                        eStat.MPPLY_AWD_HST_SAME_TEAM:Set((ftr:IsToggled()) and true or false)
                        eStat.MPPLY_HEISTNODEATHPROGREITSET:Set((ftr:IsToggled()) and 268435455 or 134217727)
                        eStat.MPPLY_AWD_HST_ULT_CHAL:Set((ftr:IsToggled()) and true or false)

                        if ftr:IsToggled() then
                            if not loggedApartmentBonus then
                                SilentLogger.LogInfo("[12mil Bonus (Apartment)] Bonus should've been applied. Don't forget to put hard difficulty ツ")
                                loggedApartmentBonus = true
                            end
                        else
                            SilentLogger.LogInfo("[12mil Bonus (Apartment)] Bonus should've been unapplied ツ")
                            loggedApartmentBonus = false
                        end
                    end
                },

                Double = {
                    hash = J("SN_Apartment_Double"),
                    name = "Double Rewards Week",
                    type = eFeatureType.Toggle,
                    desc = "Enable this during double rewards week.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Double Rewards Week (Apartment)] Cuts should've been %s ツ", (ftr:IsToggled()) and "decreased" or "increased"))
                    end
                },

                Player1 = {
                    hash = J("SN_Apartment_Player1"),
                    name = "Player 1",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 1.",
                    defv = 0,
                    lims = { 0, 10000 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 1 (Apartment)] Player 1 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player2 = {
                    hash = J("SN_Apartment_Player2"),
                    name = "Player 2",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 2.",
                    defv = 0,
                    lims = { 0, 10000 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 2 (Apartment)] Player 2 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player3 = {
                    hash = J("SN_Apartment_Player3"),
                    name = "Player 3",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 3.",
                    defv = 0,
                    lims = { 0, 10000 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 3 (Apartment)] Player 3 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player4 = {
                    hash = J("SN_Apartment_Player4"),
                    name = "Player 4",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 4.",
                    defv = 0,
                    lims = { 0, 10000 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 4 (Apartment)] Player 4 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Apply = {
                    hash = J("SN_Apartment_Apply"),
                    name = "Apply Cuts",
                    type = eFeatureType.Button,
                    desc = "Applies the selected cuts for players.",
                    func = function(team, receivers, cuts)
                        GUI.Toggle()
                        Script.Yield(1000)

                        local function SetCuts()
                            eGlobal.Heist.Apartment.Cut.Player1.Global:Set(100 - (cuts[1] * team))
                            eGlobal.Heist.Apartment.Cut.Player2.Global:Set(cuts[2])
                            eGlobal.Heist.Apartment.Cut.Player3.Global:Set(cuts[3])
                            eGlobal.Heist.Apartment.Cut.Player4.Global:Set(cuts[4])
                            eNative.PAD.SET_CURSOR_POSITION(0.775, 0.175)
                            GTA.SimulatePlayerControl(237)
                            GTA.SimulateFrontendControl(202)
                        end

                        if team ~= 1 and receivers == 0 then
                            SetCuts()
                            Script.Yield(1000)
                            eGlobal.Heist.Apartment.Cut.Player1.Local:Set(cuts[1])
                        elseif team ~= 1 and receivers == 1 then
                            SetCuts()
                            Script.Yield(1000)
                            eGlobal.Heist.Apartment.Cut.Player1.Local:Set(0)
                        elseif team == 1 or receivers == 2 then
                            eGlobal.Heist.Apartment.Cut.Player1.Local:Set(cuts[1])
                        end

                        GUI.Toggle()
                        SilentLogger.LogInfo("[Apply Cuts (Apartment)] Cuts should've been applied ツ")
                    end
                }
            }
        },

        AutoShop = {
            Preps = {
                Contract = {
                    hash = J("SN_AutoShop_Contract"),
                    name = "Contract",
                    type = eFeatureType.Combo,
                    desc = "Select the desired contract.",
                    list = eTable.Heist.AutoShop.Contracts,
                    func = function(ftr)
                        local list  = eTable.Heist.AutoShop.Contracts
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Contract (Auto Shop)] Selected contract: %s ツ", list:GetName(index)))
                    end
                },

                Complete = {
                    hash = J("SN_AutoShop_Complete"),
                    name = "Apply & Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Applies all changes and completes all preparations. Also, redraws the planning board.",
                    func = function(contract)
                        eStat.MPX_TUNER_CURRENT:Set(contract)
                        eStat.MPX_TUNER_GEN_BS:Set((contract == 1) and 4351 or 12543)
                        eLocal.Heist.AutoShop.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply & Complete Preps (Auto Shop)] Preps should've been completed ツ")
                    end
                },

                Reload = {
                    hash = J("SN_AutoShop_Reload"),
                    name = "Redraw Board",
                    type = eFeatureType.Button,
                    desc = "Redraws the planning board.",
                    func = function()
                        eLocal.Heist.AutoShop.Reload:Set(2)
                        SilentLogger.LogInfo("[Redraw Board (Auto Shop)] Board should've been redrawn ツ")
                    end
                }
            },

            Misc = {
                 Finish = {
                    hash = Utils.Joaat("SN_AutoShop_Finish"),
                    name = "Instant Finish",
                    type = eFeatureType.Button,
                    desc = "Finishes the heist instantly. Use after you can see the minimap.",
                    func = function()
                        if CONFIG.instant_finish.auto_shop == 1 then
                            Helper.NewInstantFinishHeist()

                            SilentLogger.LogInfo("[Instant Finish (Auto Shop)] Heist should've been finished. Method used: New ツ")
                            return
                        end

                        GTA.ForceScriptHost(eScript.Heist.AutoShop)
                        Script.Yield(1000)
                        eLocal.Heist.AutoShop.Finish.Step1:Set(51338977)
                        eLocal.Heist.AutoShop.Finish.Step2:Set(101)

                        SilentLogger.LogInfo("[Instant Finish (Auto Shop)] Heist should've been finished. Method used: Old ツ")
                    end
                },

                Cooldown = {
                    hash = J("SN_AutoShop_Cooldown"),
                    name = "Kill Cooldown",
                    type = eFeatureType.Button,
                    desc = "Skips the heist's cooldown. Doesn't skip the cooldown between transactions (20 min).",
                    func = function()
                        for i = 0, 7 do
                            eStat[F("MPX_TUNER_CONTRACT%d_POSIX", i)]:Set(0)
                        end

                        eTunable.Heist.AutoShop.Cooldown:Set(0)

                        SilentLogger.LogInfo("[Kill Cooldown (Auto Shop)] Cooldowns should've been killed ツ")
                    end
                }
            },

            Payout = {
                Select = {
                    hash = J("SN_AutoShop_Select"),
                    name = "Payout",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired payout.",
                    defv = 0,
                    lims = { 0, 2000000 },
                    step = 100000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Payout (Auto Shop)] Payout should've been changed. Don't forget to apply ツ")
                    end
                },

                Max = {
                    hash = J("SN_AutoShop_Max"),
                    name = "Max",
                    type = eFeatureType.Button,
                    desc = "Maximizes the payout, but doesn't apply it.",
                    func = function()
                        SilentLogger.LogInfo("[Max (Auto Shop)] Payout should've been maximized. Don't forget to apply ツ")
                    end
                },

                Apply = {
                    hash = J("SN_AutoShop_Apply"),
                    name = "Apply Payout",
                    type = eFeatureType.Button,
                    desc = "Applies the selected payout. Use after you can see the minimap.",
                    func = function(payout)
                        eTunable.Heist.AutoShop.Payout.First:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Second:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Third:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Fourth:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Fifth:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Sixth:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Seventh:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Eight:Set(payout)
                        eTunable.Heist.AutoShop.Payout.Fee:Set(0.0)
                        SilentLogger.LogInfo("[Apply Payout (Auto Shop)] Payout should've been applied ツ")
                    end
                }
            }
        },

        CayoPerico = {
            Preps = {
                Difficulty = {
                    hash = J("SN_CayoPerico_Difficulty"),
                    name = "Difficulty",
                    type = eFeatureType.Combo,
                    desc = "Select the desired difficulty.",
                    list = eTable.Heist.CayoPerico.Difficulties,
                    func = function(ftr)
                        local list  = eTable.Heist.CayoPerico.Difficulties
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Difficulty (Cayo Perico)] Selected difficulty: %s ツ", list:GetName(index)))
                    end
                },

                Approach = {
                    hash = J("SN_CayoPerico_Approach"),
                    name = "Approach",
                    type = eFeatureType.Combo,
                    desc = "Select the desired approach.",
                    list = eTable.Heist.CayoPerico.Approaches,
                    func = function(ftr)
                        local list  = eTable.Heist.CayoPerico.Approaches
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Approach (Cayo Perico)] Selected approach: %s ツ", list:GetName(index)))
                    end
                },

                Loadout = {
                    hash = J("SN_CayoPerico_Loadout"),
                    name = "Loadout",
                    type = eFeatureType.Combo,
                    desc = "Select the desired loadout.",
                    list = eTable.Heist.CayoPerico.Loadouts,
                    func = function(ftr)
                        local list  = eTable.Heist.CayoPerico.Loadouts
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Loadout (Cayo Perico)] Selected loadout: %s ツ", list:GetName(index)))
                    end
                },

                Target = {
                    Primary = {
                        hash = J("SN_CayoPerico_PrimaryTarget"),
                        name = "Target",
                        type = eFeatureType.Combo,
                        desc = "Select the desired primary target.",
                        list = eTable.Heist.CayoPerico.Targets.Primary,
                        func = function(ftr)
                            local list  = eTable.Heist.CayoPerico.Targets.Primary
                            local index = list[ftr:GetListIndex() + 1].index
                            SilentLogger.LogInfo(F("[Primary Target (Cayo Perico)] Selected primary target: %s ツ", list:GetName(index)))
                        end
                    },

                    Secondary = {
                        Compound = {
                            hash = J("SN_CayoPerico_CompoundTarget"),
                            name = "Com. Target",
                            type = eFeatureType.Combo,
                            desc = "Select the desired compound target.",
                            list = eTable.Heist.CayoPerico.Targets.Secondary,
                            func = function(ftr)
                                local list  = eTable.Heist.CayoPerico.Targets.Secondary
                                local index = list[ftr:GetListIndex() + 1].index
                                SilentLogger.LogInfo(F("[Compound Target (Cayo Perico)] Selected compound target: %s ツ", list:GetName(index)))
                            end
                        },

                        Island = {
                            hash = J("SN_CayoPerico_IslandTarget"),
                            name = "Isl. Target",
                            type = eFeatureType.Combo,
                            desc = "Select the desired island target.",
                            list = eTable.Heist.CayoPerico.Targets.Secondary,
                            func = function(ftr)
                                local list  = eTable.Heist.CayoPerico.Targets.Secondary
                                local index = list[ftr:GetListIndex() + 1].index
                                SilentLogger.LogInfo(F("[Island Target (Cayo Perico)] Selected island target: %s ツ", list:GetName(index)))
                            end
                        }
                    },

                    Amount = {
                        Compound = {
                            hash = J("SN_CayoPerico_CompoundAmount"),
                            name = "Com. Amount",
                            type = eFeatureType.Combo,
                            desc = "Select the desired compound target amount.",
                            list = eTable.Heist.CayoPerico.Targets.Amounts.Compound,
                            func = function(ftr)
                                local list  = eTable.Heist.CayoPerico.Targets.Amounts.Compound
                                local index = list[ftr:GetListIndex() + 1].index
                                SilentLogger.LogInfo(F("[Compound Amount (Cayo Perico)] Selected compound amount: %s ツ", list:GetName(index)))
                            end
                        },

                        Island = {
                            hash = J("SN_CayoPerico_IslandAmount"),
                            name = "Isl. Amount",
                            type = eFeatureType.Combo,
                            desc = "Select the desired island target amount.",
                            list = eTable.Heist.CayoPerico.Targets.Amounts.Island,
                            func = function(ftr)
                                local list  = eTable.Heist.CayoPerico.Targets.Amounts.Island
                                local index = list[ftr:GetListIndex() + 1].index
                                SilentLogger.LogInfo(F("[Island Amount (Cayo Perico)] Selected island amount: %s ツ", list:GetName(index)))
                            end
                        },

                        Arts = {
                            hash = J("SN_CayoPerico_ArtsAmount"),
                            name = "Arts Amount",
                            type = eFeatureType.Combo,
                            desc = "Select the desired compound arts amount.",
                            list = eTable.Heist.CayoPerico.Targets.Amounts.Arts,
                            func = function(ftr)
                                local list  = eTable.Heist.CayoPerico.Targets.Amounts.Arts
                                local index = list[ftr:GetListIndex() + 1].index
                                SilentLogger.LogInfo(F("[Arts Amount (Cayo Perico)] Selected arts amount: %s ツ", list:GetName(index)))
                            end
                        }
                    },

                    Value = {
                        Default = {
                            hash = J("SN_CayoPerico_DefaultValue"),
                            name = "Default",
                            type = eFeatureType.Button,
                            desc = "Resets the values to default.",
                            func = function()
                                SilentLogger.LogInfo("[Default (Cayo Perico)] Values should've been reset to default ツ")
                            end
                        },

                        Cash = {
                            hash = J("SN_CayoPerico_CashValue"),
                            name = "Cash Value",
                            type = eFeatureType.InputInt,
                            desc = "Select the desired cash value.",
                            defv = eTable.Heist.CayoPerico.Values.Cash,
                            lims = { 0, 2550000 },
                            step = 50000,
                            func = function()
                                SilentLogger.LogInfo("[Cash Value (Cayo Perico)] Cash value should've been changed. Don't forget to apply ツ")
                            end
                        },

                        Weed = {
                            hash = J("SN_CayoPerico_WeedValue"),
                            name = "Weed Value",
                            type = eFeatureType.InputInt,
                            desc = "Select the desired weed value.",
                            defv = eTable.Heist.CayoPerico.Values.Weed,
                            lims = { 0, 2550000 },
                            step = 50000,
                            func = function()
                                SilentLogger.LogInfo("[Weed Value (Cayo Perico)] Weed value should've been changed. Don't forget to apply ツ")
                            end
                        },

                        Coke = {
                            hash = J("SN_CayoPerico_CokeValue"),
                            name = "Coke Value",
                            type = eFeatureType.InputInt,
                            desc = "Select the desired coke value.",
                            defv = eTable.Heist.CayoPerico.Values.Coke,
                            lims = { 0, 2550000 },
                            step = 50000,
                            func = function()
                                SilentLogger.LogInfo("[Coke Value (Cayo Perico)] Coke value should've been changed. Don't forget to apply ツ")
                            end
                        },

                        Gold = {
                            hash = J("SN_CayoPerico_GoldValue"),
                            name = "Gold Value",
                            type = eFeatureType.InputInt,
                            desc = "Select the desired gold value.",
                            defv = eTable.Heist.CayoPerico.Values.Gold,
                            lims = { 0, 2550000 },
                            step = 50000,
                            func = function()
                                SilentLogger.LogInfo("[Gold Value (Cayo Perico)] Gold value should've been changed. Don't forget to apply ツ")
                            end
                        },

                        Arts = {
                            hash = J("SN_CayoPerico_ArtsValue"),
                            name = "Arts Value",
                            type = eFeatureType.InputInt,
                            desc = "Select the desired arts value.",
                            defv = eTable.Heist.CayoPerico.Values.Arts,
                            lims = { 0, 2550000 },
                            step = 50000,
                            func = function()
                                SilentLogger.LogInfo("[Arts Value (Cayo Perico)] Arts value should've been changed. Don't forget to apply ツ")
                            end
                        }
                    }
                },

                Advanced = {
                    hash = J("SN_CayoPerico_Advanced"),
                    name = "Advanced",
                    type = eFeatureType.Toggle,
                    desc = "Allows you to change the value of secondary targets. Use with caution.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Advanced (Cayo Perico)] Advanced mode should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                    end
                },

                Complete = {
                    hash = J("SN_CayoPerico_Complete"),
                    name = "Apply & Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Applies all changes and completes all preparations. Also, reloads the planning screen.",
                    func = function(difficulty, approach, loadout, primaryTarget, compoundTarget, compoundAmount, artsAmount, islandTarget, islandAmount, cashValue, weedValue, cokeValue, goldValue, artsValue)
                        eStat.MPX_H4_PROGRESS:Set(difficulty)
                        eStat.MPX_H4_MISSIONS:Set(approach)
                        eStat.MPX_H4CNF_WEAPONS:Set(loadout)
                        eStat.MPX_H4CNF_TARGET:Set(primaryTarget)
                        eStat.MPX_H4LOOT_CASH_C:Set((eStat.MPX_H4LOOT_CASH_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_CASH_C_SCOPED:Set((eStat.MPX_H4LOOT_CASH_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_WEED_C:Set((eStat.MPX_H4LOOT_WEED_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_WEED_C_SCOPED:Set((eStat.MPX_H4LOOT_WEED_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_COKE_C:Set((eStat.MPX_H4LOOT_COKE_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_COKE_C_SCOPED:Set((eStat.MPX_H4LOOT_COKE_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_GOLD_C:Set((eStat.MPX_H4LOOT_GOLD_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_GOLD_C_SCOPED:Set((eStat.MPX_H4LOOT_GOLD_C.stat:find(compoundTarget)) and compoundAmount or 0)
                        eStat.MPX_H4LOOT_PAINT:Set((artsAmount ~= 0) and artsAmount or 0)
                        eStat.MPX_H4LOOT_PAINT_SCOPED:Set((artsAmount ~= 0) and artsAmount or 0)
                        eStat.MPX_H4LOOT_CASH_I:Set((eStat.MPX_H4LOOT_CASH_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_CASH_I_SCOPED:Set((eStat.MPX_H4LOOT_CASH_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_WEED_I:Set((eStat.MPX_H4LOOT_WEED_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_WEED_I_SCOPED:Set((eStat.MPX_H4LOOT_WEED_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_COKE_I:Set((eStat.MPX_H4LOOT_COKE_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_COKE_I_SCOPED:Set((eStat.MPX_H4LOOT_COKE_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_GOLD_I:Set((eStat.MPX_H4LOOT_GOLD_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_GOLD_I_SCOPED:Set((eStat.MPX_H4LOOT_GOLD_I.stat:find(islandTarget)) and islandAmount or 0)
                        eStat.MPX_H4LOOT_CASH_V:Set((compoundTarget ~= 0 or islandTarget ~= 0) and cashValue or 0)
                        eStat.MPX_H4LOOT_WEED_V:Set((compoundTarget ~= 0 or islandTarget ~= 0) and weedValue or 0)
                        eStat.MPX_H4LOOT_COKE_V:Set((compoundTarget ~= 0 or islandTarget ~= 0) and cokeValue or 0)
                        eStat.MPX_H4LOOT_GOLD_V:Set((compoundTarget ~= 0 or islandTarget ~= 0) and goldValue or 0)
                        eStat.MPX_H4LOOT_PAINT_V:Set((artsAmount ~= 0) and artsValue or 0)
                        eStat.MPX_H4CNF_UNIFORM:Set(-1)
                        eStat.MPX_H4CNF_GRAPPEL:Set(-1)
                        eStat.MPX_H4CNF_TROJAN:Set(5)
                        eStat.MPX_H4CNF_WEP_DISRP:Set(3)
                        eStat.MPX_H4CNF_ARM_DISRP:Set(3)
                        eStat.MPX_H4CNF_HEL_DISRP:Set(3)
                        eStat.MPX_H4_PLAYTHROUGH_STATUS:Set(10)

                        if CONFIG.unlock_all_poi.cayo_perico then
                            eStat.MPX_H4CNF_BS_GEN:Set(-1)
                            eStat.MPX_H4CNF_BS_ENTR:Set(63)
                            eStat.MPX_H4CNF_BS_ABIL:Set(63)
                            eStat.MPX_H4CNF_APPROACH:Set(-1)
                        end

                        eLocal.Heist.CayoPerico.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply & Complete Preps (Cayo Perico)] Preps should've been completed ツ")
                    end
                },

                Reset = {
                    hash = J("SN_CayoPerico_Reset"),
                    name = "Reset Preps",
                    type = eFeatureType.Button,
                    desc = "Resets all preparations. Also, reloads the planning screen.",
                    func = function()
                        eStat.MPX_H4_PROGRESS:Set(0)
                        eStat.MPX_H4_MISSIONS:Set(0)
                        eStat.MPX_H4CNF_APPROACH:Set(0)
                        eStat.MPX_H4CNF_TARGET:Set(-1)
                        eStat.MPX_H4CNF_BS_GEN:Set(0)
                        eStat.MPX_H4CNF_BS_ENTR:Set(0)
                        eStat.H4_PLAYTHROUGH_STATUS:Set(0)
                        eLocal.Heist.CayoPerico.Reload:Set(2)
                        SilentLogger.LogInfo("[Reset Preps (Cayo Perico)] Preps should've been reset ツ")
                    end
                },

                Reload = {
                    hash = J("SN_CayoPerico_Reload"),
                    name = "Reload Screen",
                    type = eFeatureType.Button,
                    desc = "Reloads the planning screen.",
                    func = function()
                        eLocal.Heist.CayoPerico.Reload:Set(2)
                        SilentLogger.LogInfo("[Reload Screen (Cayo Perico)] Screen should've been reloaded ツ")
                    end
                }
            },

            Misc = {
                Force = {
                    hash = J("SN_CayoPerico_Force"),
                    name = "Force Ready",
                    type = eFeatureType.Button,
                    desc = "Forces everyone to be «Ready».",
                    func = function()
                        GTA.ForceScriptHost(eScript.Heist.CayoPerico)
                        Script.Yield(1000)

                        for i = 2, 4 do
                            eGlobal.Heist.CayoPerico.Ready[F("Player%d", i)]:Set(1)
                        end

                        SilentLogger.LogInfo("[Force Ready (Cayo Perico)] Everyone should've been forced ready ツ")
                    end
                },

                Finish = {
                    hash = Utils.Joaat("SN_CayoPerico_Finish"),
                    name = "Instant Finish",
                    type = eFeatureType.Button,
                    desc = "Finishes the heist instantly. Use after you can see the minimap.",
                    func = function()
                        if CONFIG.instant_finish.cayo_perico == 1 then
                            Helper.NewInstantFinishHeist()

                            SilentLogger.LogInfo("[Instant Finish (Cayo Perico)] Heist should've been finished. Method used: New ツ")
                            return
                        end

                        GTA.ForceScriptHost(eScript.Heist.CayoPerico)
                        Script.Yield(1000)
                        eLocal.Heist.CayoPerico.Finish.Step1:Set(9)
                        eLocal.Heist.CayoPerico.Finish.Step2:Set(50)

                        SilentLogger.LogInfo("[Instant Finish (Cayo Perico)] Heist should've been finished. Method used: Old ツ")
                    end
                },

                FingerprintHack = {
                    hash = J("SN_CayoPerico_FingerprintHack"),
                    name = "Bypass Fingerprint Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the fingerprint hacking process.",
                    func = function()
                        eLocal.Heist.CayoPerico.Bypass.FingerprintHack:Set(5)
                        SilentLogger.LogInfo("[Bypass Fingerprint Hack (Cayo Perico)] Hacking process should've been skipped ツ")
                    end
                },

                PlasmaCutterCut = {
                    hash = J("SN_CayoPerico_PlasmaCutterCut"),
                    name = "Bypass Plasma Cutter Cut",
                    type = eFeatureType.Button,
                    desc = "Skips the cutting process.",
                    func = function()
                        eLocal.Heist.CayoPerico.Bypass.PlasmaCutterCut:Set(100)
                        SilentLogger.LogInfo("[Bypass Plasma Cutter Cut (Cayo Perico)] Cutting process should've been skipped ツ")
                    end
                },

                DrainagePipeCut = {
                    hash = J("SN_CayoPerico_DrainagePipeCut"),
                    name = "Bypass Drainage Pipe Cut",
                    type = eFeatureType.Button,
                    desc = "Skips the cutting process.",
                    func = function()
                        eLocal.Heist.CayoPerico.Bypass.DrainagePipeCut:Set(6)
                        SilentLogger.LogInfo("[Bypass Drainage Pipe Cut (Cayo Perico)] Cutting process should've been skipped ツ")
                    end
                },

                Bag = {
                    hash = J("SN_CayoPerico_Bag"),
                    name = "Woman's Bag",
                    type = eFeatureType.Toggle,
                    desc = "Increases the size of the bag. Use with caution.",
                    func = function(ftr)
                        if GTA.IsInSession() then
                            if ftr:IsToggled() then
                                eTunable.Heist.CayoPerico.Bag.MaxCapacity:Set(99999)

                                if not loggedCayoBag then
                                    SilentLogger.LogInfo("[Woman's Bag (Cayo Perico)] Bag size should've been increased ツ")
                                    loggedCayoBag = true
                                end
                            else
                                eTunable.Heist.CayoPerico.Bag.MaxCapacity:Reset()

                                SilentLogger.LogInfo("[Woman's Bag (Cayo Perico)] Bag size should've been reset ツ")
                                loggedCayoBag = false
                            end
                        end
                    end
                },

                Cooldown = {
                    Solo = {
                        hash = J("SN_CayoPerico_SoloCooldown"),
                        name = "Kill Cooldown (after solo)",
                        type = eFeatureType.Button,
                        desc = "Skips the heist's cooldown after you have played solo. Doesn't skip the cooldown between transactions (20 min). Go offline and online after using.",
                        func = function()
                            eStat.MPX_H4_TARGET_POSIX:Set(1659643454)
                            eStat.MPX_H4_COOLDOWN:Set(0)
                            eStat.MPX_H4_COOLDOWN_HARD:Set(0)
                            SilentLogger.LogInfo("[Kill Cooldown (Cayo Perico)] Cooldown should've been killed ツ")
                        end
                    },

                    Team = {
                        hash = J("SN_CayoPerico_TeamCooldown"),
                        name = "Kill Cooldown (after team)",
                        type = eFeatureType.Button,
                        desc = "Skips the heist's cooldown after you have played with a team. Doesn't skip the cooldown between transactions (20 min). Go offline and online after using.",
                        func = function()
                            eStat.MPX_H4_TARGET_POSIX:Set(1659429119)
                            eStat.MPX_H4_COOLDOWN:Set(0)
                            eStat.MPX_H4_COOLDOWN_HARD:Set(0)
                            SilentLogger.LogInfo("[Kill Cooldown (Cayo Perico)] Cooldown should've been killed ツ")
                        end
                    },

                    Offline = {
                        hash = J("SN_CayoPerico_Offline"),
                        name = "Go Offline",
                        type = eFeatureType.Button,
                        desc = "Leaves from GTA Online.",
                        func = function()
                            eGlobal.Session.Switch:Set(1)
                            eGlobal.Session.Quit:Set(-1)
                            SilentLogger.LogInfo("[Go Offline (Cayo Perico)] Offline should've been loaded ツ")
                        end
                    },

                    Online = {
                        hash = J("SN_CayoPerico_Online"),
                        name = "Go Online",
                        type = eFeatureType.Button,
                        desc = "Connects to GTA Online.",
                        func = function()
                            GTA.StartSession(eTable.Session.Types.NewPublic)
                            SilentLogger.LogInfo("[Go Online (Cayo Perico)] Online should've been loaded ツ")
                        end
                    }
                }
            },

            Cuts = {
                Team = {
                    hash = J("SN_CayoPerico_Team"),
                    name = "Team",
                    type = eFeatureType.Combo,
                    desc = "Select your number of players.",
                    list = eTable.Heist.Generic.Team,
                    func = function(ftr)
                        local list = eTable.Heist.Generic.Team
                        local team = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Team (Cayo Perico)] Selected team size: %s ツ", list:GetName(team)))
                    end
                },

                Presets = {
                    hash = J("SN_CayoPerico_Presets"),
                    name = "Presets",
                    type = eFeatureType.Combo,
                    desc = "Select one of the ready-made presets. 2.55mil Payout only works if you've set the Difficulty through the script and you don't have any Secondary Targets.",
                    list = eTable.Heist.CayoPerico.Presets,
                    func = function()
                        Helper.SetCayoMaxPayout()
                        Script.Yield()
                    end
                },

                Crew = {
                    hash = J("SN_CayoPerico_Crew"),
                    name = "Remove Crew Cuts",
                    type = eFeatureType.Toggle,
                    desc = "Removes fencing fee and Pavel's cut. Can't be used with «2.55mil Payout».",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            eTunable.Heist.CayoPerico.Cut.Pavel:Set(0)
                            eTunable.Heist.CayoPerico.Cut.Fee:Set(0)

                            if not loggedCayoCrew then
                                SilentLogger.LogInfo("[Remove Crew Cuts (Cayo Perico)] Crew cuts should've been removed ツ")
                                loggedCayoCrew = true
                            end
                        else
                            eTunable.Heist.CayoPerico.Cut.Pavel:Reset()
                            eTunable.Heist.CayoPerico.Cut.Fee:Reset()
                            SilentLogger.LogInfo("[Remove Crew Cuts (Cayo Perico)] Crew cuts should've been reset ツ")
                            loggedCayoCrew = false
                        end
                    end
                },

                Player1 = {
                    hash = J("SN_CayoPerico_Player1"),
                    name = "Player 1",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 1.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 1 (Cayo Perico)] Player 1 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player2 = {
                    hash = J("SN_CayoPerico_Player2"),
                    name = "Player 2",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 2.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 2 (Cayo Perico)] Player 2 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player3 = {
                    hash = J("SN_CayoPerico_Player3"),
                    name = "Player 3",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 3.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 3 (Cayo Perico)] Player 3 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player4 = {
                    hash = J("SN_CayoPerico_Player4"),
                    name = "Player 4",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 4.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 4 (Cayo Perico)] Player 4 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Apply = {
                    hash = J("SN_CayoPerico_Apply"),
                    name = "Apply Cuts",
                    type = eFeatureType.Button,
                    desc = "Applies the selected cuts for players.",
                    func = function(cuts)
                        for i = 1, 4 do
                            eGlobal.Heist.CayoPerico.Cut[F("Player%d", i)]:Set(cuts[i])
                        end
                        SilentLogger.LogInfo("[Apply Cuts (Cayo Perico)] Cuts should've been applied ツ")
                    end
                }
            },

            Presets = {
                File = {
                    hash = J("SN_CayoPerico_File"),
                    name = "File",
                    type = eFeatureType.Combo,
                    desc = "Select the desired preset.",
                    list = eTable.Heist.CayoPerico.Files,
                    func = function(ftr)
                        local list  = eTable.Heist.CayoPerico.Files
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[File (Cayo Perico)] Selected heist preset: %s ツ", (list:GetName(index) == "") and "Empty" or list:GetName(index)))
                    end
                },

                Load = {
                    hash = J("SN_CayoPerico_Load"),
                    name = "Load",
                    type = eFeatureType.Button,
                    desc = "Loads the selected preset.",
                    func = function(file)
                        local path = F("%s\\%s.json", CAYO_DIR, file)

                        if FileMgr.DoesFileExist(path) then
                            local preps = Json.DecodeFromFile(path)
                            Helper.ApplyCayoPreset(preps)
                            SilentLogger.LogInfo(F("[Load (Cayo Perico)] Preset «%s» should've been loaded ツ", file))
                            return
                        end

                        SilentLogger.LogError(F("[Load (Cayo Perico)] Preset «%s» doesn't exist ツ", (file == "") and "Empty" or file))
                    end
                },

                Remove = {
                    hash = J("SN_CayoPerico_Remove"),
                    name = "Remove",
                    type = eFeatureType.Button,
                    desc = "Removes the selected preset.",
                    func = function(file)
                        local path = F("%s\\%s.json", CAYO_DIR, file)

                        if FileMgr.DoesFileExist(path) then
                            FileMgr.DeleteFile(path)
                            Helper.RefreshFiles()
                            SilentLogger.LogInfo(F("[Remove (Cayo Perico)] Preset «%s» should've been removed ツ", file))
                            return
                        end

                        SilentLogger.LogError(F("[Remove (Cayo Perico)] Preset «%s» doesn't exist ツ", (file == "") and "Empty" or file))
                    end
                },

                Refresh = {
                    hash = J("SN_CayoPerico_Refresh"),
                    name = "Refresh",
                    type = eFeatureType.Button,
                    desc = "Refreshes the list of presets.",
                    func = function()
                        Helper.RefreshFiles()
                        SilentLogger.LogInfo("[Refresh (Cayo Perico)] Heist presets should've been refreshed ツ")
                    end
                },

                Name = {
                    hash = J("SN_CayoPerico_Name"),
                    name = "QuickPreset",
                    type = eFeatureType.InputText,
                    desc = "Input the desired preset name."
                },

                Save = {
                    hash = J("SN_CayoPerico_Save"),
                    name = "Save",
                    type = eFeatureType.Button,
                    desc = "Saves the current preparations to the file.",
                    func = function(file, preps)
                        local path = F("%s\\%s.json", CAYO_DIR, file)
                        FileMgr.CreateHeistPresetsDirs()
                        Json.EncodeToFile(path, preps)
                        Helper.RefreshFiles()
                        SilentLogger.LogInfo(F("[Save (Cayo Perico)] Preset «%s» should've been saved ツ", file))
                    end
                },

                Copy = {
                    hash = J("SN_CayoPerico_Copy"),
                    name = "Copy Folder Path",
                    type = eFeatureType.Button,
                    desc = "Copies the presets folder path to the clipboard.",
                    func = function()
                        FileMgr.CreateHeistPresetsDirs()
                        ImGui.SetClipboardText(CAYO_DIR)
                        SilentLogger.LogInfo("[Copy Folder Path (Cayo Perico)] Presets folder path should've been copied ツ")
                    end
                }
            }
        },

        DiamondCasino = {
            Preps = {
                Difficulty = {
                    hash = J("SN_DiamondCasino_Difficulty"),
                    name = "Difficulty",
                    type = eFeatureType.Combo,
                    desc = "Select the desired difficulty.",
                    list = eTable.Heist.DiamondCasino.Difficulties,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Difficulties
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Difficulty (Diamond Casino)] Selected difficulty: %s ツ", list:GetName(index)))
                    end
                },

                Approach = {
                    hash = J("SN_DiamondCasino_Approach"),
                    name = "Approach",
                    type = eFeatureType.Combo,
                    desc = "Select the desired approach.",
                    list = eTable.Heist.DiamondCasino.Approaches,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Approaches
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Approach (Diamond Casino)] Selected approach: %s ツ", list:GetName(index)))
                    end
                },

                Gunman = {
                    hash = J("SN_DiamondCasino_Gunman"),
                    name = "Gunman",
                    type = eFeatureType.Combo,
                    desc = "Select the desired gunman.",
                    list = eTable.Heist.DiamondCasino.Gunmans,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Gunmans
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Gunman (Diamond Casino)] Selected gunman: %s ツ", list:GetName(index)))
                    end
                },

                Loadout = {
                    hash = J("SN_DiamondCasino_Loadout"),
                    name = "Loadout",
                    type = eFeatureType.Combo,
                    desc = "Select the desired loadout.",
                    list = eTable.Heist.DiamondCasino.Loadouts,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Loadouts
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Loadout (Diamond Casino)] Selected loadout: %s ツ", list:GetName(index)))
                    end
                },

                Driver = {
                    hash = J("SN_DiamondCasino_Driver"),
                    name = "Driver",
                    type = eFeatureType.Combo,
                    desc = "Select the desired driver.",
                    list = eTable.Heist.DiamondCasino.Drivers,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Drivers
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Driver (Diamond Casino)] Selected driver: %s ツ", list:GetName(index)))
                    end
                },

                Vehicles = {
                    hash = J("SN_DiamondCasino_Vehicles"),
                    name = "Vehicles",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicles.",
                    list = eTable.Heist.DiamondCasino.Vehicles,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Vehicles
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Vehicles (Diamond Casino)] Selected vehicles: %s ツ", list:GetName(index)))
                    end
                },

                Hacker = {
                    hash = J("SN_DiamondCasino_Hacker"),
                    name = "Hacker",
                    type = eFeatureType.Combo,
                    desc = "Select the desired hacker.",
                    list = eTable.Heist.DiamondCasino.Hackers,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Hackers
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Hacker (Diamond Casino)] Selected hacker: %s ツ", list:GetName(index)))
                    end
                },

                Masks = {
                    hash = J("SN_DiamondCasino_Masks"),
                    name = "Masks",
                    type = eFeatureType.Combo,
                    desc = "Select the desired masks.",
                    list = eTable.Heist.DiamondCasino.Masks,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Masks
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Masks (Diamond Casino)] Selected masks: %s ツ", list:GetName(index)))
                    end
                },

                Keycards = {
                    hash = J("SN_DiamondCasino_Keycards"),
                    name = "Keycards",
                    type = eFeatureType.Combo,
                    desc = "Select the desired keycards level.",
                    list = eTable.Heist.DiamondCasino.Keycards,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Keycards
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Keycards (Diamond Casino)] Selected keycards level: %s ツ", list:GetName(index)))
                    end
                },

                Guards = {
                    hash = J("SN_DiamondCasino_Guards"),
                    name = "Guards",
                    type = eFeatureType.Combo,
                    desc = "Select the desired guards strength.",
                    list = eTable.Heist.DiamondCasino.Guards,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Guards
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Guards (Diamond Casino)] Selected guards strength: %s ツ", list:GetName(index)))
                    end
                },

                Target = {
                    hash = J("SN_DiamondCasino_Target"),
                    name = "Target",
                    type = eFeatureType.Combo,
                    desc = "Select the desired target.",
                    list = eTable.Heist.DiamondCasino.Targets,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Targets
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Target (Diamond Casino)] Selected target: %s ツ", list:GetName(index)))
                    end
                },

                Complete = {
                    hash = J("SN_DiamondCasino_Complete"),
                    name = "Apply & Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Applies all changes and completes all preparations. Also, redraws the planning board.",
                    func = function(difficulty, approach, gunman, driver, hacker, masks, guards, keycards, target, loadout, vehicles, unlock)
                        local function SetApproach(lastApproach, hardApproach, normalApproach)
                            eStat.MPX_H3_LAST_APPROACH:Set(lastApproach)
                            eStat.MPX_H3_HARD_APPROACH:Set(hardApproach)
                            eStat.MPX_H3_APPROACH:Set(normalApproach)
                            eStat.MPX_H3OPT_APPROACH:Set(approach)
                        end

                        local normalApproaches = {
                            [1] = { 3, 2, 1 },
                            [2] = { 3, 1, 2 },
                            [3] = { 1, 2, 3 }
                        }

                        local hardApproaches = {
                            [1] = { 2, 1, 3 },
                            [2] = { 1, 2, 3 },
                            [3] = { 2, 3, 1 }
                        }

                        if difficulty == 0 then
                            SetApproach(U(normalApproaches[approach]))
                        else
                            SetApproach(U(hardApproaches[approach]))
                        end

                        eStat.MPX_H3OPT_CREWWEAP:Set(gunman)
                        eStat.MPX_H3OPT_WEAPS:Set(loadout)
                        eStat.MPX_H3OPT_CREWDRIVER:Set(driver)
                        eStat.MPX_H3OPT_VEHS:Set(vehicles)
                        eStat.MPX_H3OPT_CREWHACKER:Set(hacker)
                        eStat.MPX_H3OPT_TARGET:Set(target)
                        eStat.MPX_H3OPT_MASKS:Set(masks)
                        eStat.MPX_H3OPT_DISRUPTSHIP:Set(guards)
                        eStat.MPX_H3OPT_KEYLEVELS:Set(keycards)
                        eStat.MPX_H3OPT_BODYARMORLVL:Set(-1)
                        eStat.MPX_H3OPT_BITSET0:Set(-1)
                        eStat.MPX_H3OPT_BITSET1:Set(-1)
                        eStat.MPX_H3OPT_COMPLETEDPOSIX:Set(-1)

                        if CONFIG.unlock_all_poi.diamond_casino then
                            eStat.MPX_H3OPT_POI:Set(-1)
                            eStat.MPX_H3OPT_ACCESSPOINTS:Set(-1)
                            eStat.MPX_CAS_HEIST_NOTS:Set(-1)
                            eStat.MPX_CAS_HEIST_FLOW:Set(-1)
                        end

                        eLocal.Heist.DiamondCasino.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply & Complete Preps (Diamond Casino)] Preps should've been completed ツ")
                    end
                },

                Reset = {
                    hash = J("SN_DiamondCasino_Reset"),
                    name = "Reset Preps",
                    type = eFeatureType.Button,
                    desc = "Resets all preparations. Also, redraws the planning board.",
                    func = function()
                        eStat.MPX_H3_LAST_APPROACH:Set(0)
                        eStat.MPX_H3_HARD_APPROACH:Set(0)
                        eStat.MPX_H3_APPROACH:Set(0)
                        eStat.MPX_H3OPT_APPROACH:Set(0)
                        eStat.MPX_H3OPT_CREWWEAP:Set(0)
                        eStat.MPX_H3OPT_WEAPS:Set(0)
                        eStat.MPX_H3OPT_CREWDRIVER:Set(0)
                        eStat.MPX_H3OPT_VEHS:Set(0)
                        eStat.MPX_H3OPT_CREWHACKER:Set(0)
                        eStat.MPX_H3OPT_MASKS:Set(0)
                        eStat.MPX_H3OPT_TARGET:Set(0)
                        eStat.MPX_H3OPT_DISRUPTSHIP:Set(0)
                        eStat.MPX_H3OPT_BODYARMORLVL:Set(01)
                        eStat.MPX_H3OPT_KEYLEVELS:Set(0)
                        eStat.MPX_H3OPT_BITSET0:Set(0)
                        eStat.MPX_H3OPT_BITSET1:Set(0)
                        eStat.MPX_H3OPT_POI:Set(0)
                        eStat.MPX_H3OPT_ACCESSPOINTS:Set(0)
                        eStat.MPX_CAS_HEIST_NOTS:Set(0)
                        eStat.MPX_CAS_HEIST_FLOW:Set(0)
                        eStat.MPX_H3_BOARD_DIALOGUE0:Set(0)
                        eStat.MPX_H3_BOARD_DIALOGUE1:Set(0)
                        eStat.MPX_H3_BOARD_DIALOGUE2:Set(0)
                        eStat.MPPLY_H3_COOLDOWN:Set(0)
                        eStat.MPX_H3OPT_COMPLETEDPOSIX:Set(0)
                        eLocal.Heist.DiamondCasino.Reload:Set(2)
                        SilentLogger.LogInfo("[Reset Preps (Diamond Casino)] Preps should've been reset ツ")
                    end
                },

                Reload = {
                    hash = J("SN_DiamondCasino_Reload"),
                    name = "Redraw Board",
                    type = eFeatureType.Button,
                    desc = "Redraws the planning board.",
                    func = function()
                        eLocal.Heist.DiamondCasino.Reload:Set(2)
                        SilentLogger.LogInfo("[Redraw Board (Diamond Casino)] Board should've been redrawn ツ")
                    end
                }
            },

            Misc = {
                Force = {
                    hash = J("SN_DiamondCasino_Force"),
                    name = "Force Ready",
                    type = eFeatureType.Button,
                    desc = "Forces everyone to be «Ready».",
                    func = function()
                        GTA.ForceScriptHost(eScript.Heist.DiamondCasino)
                        Script.Yield(1000)

                        for i = 2, 4 do
                            eGlobal.Heist.DiamondCasino.Ready[F("Player%d", i)]:Set(1)
                        end

                        SilentLogger.LogInfo("[Force Ready (Diamond Casino)] Everyone should've been forced ready ツ")
                    end
                },

                Finish = {
                    hash = J("SN_DiamondCasino_Finish"),
                    name = "Instant Finish",
                    type = eFeatureType.Button,
                    desc = "Finishes the heist instantly. Use after you can see the minimap.",
                    func = function()
                        if CONFIG.instant_finish.diamond_casino == 1 then
                            Helper.NewInstantFinishHeist()

                            SilentLogger.LogInfo("[Instant Finish (Diamond Casino)] Heist should've been finished. Method used: New ツ")
                            return
                        end

                        GTA.ForceScriptHost(eScript.Heist.DiamondCasino)
                        Script.Yield(1000)

                        if eStat.MPX_H3OPT_APPROACH:Get() == 3 then
                            eLocal.Heist.DiamondCasino.Finish.Step1:Set(12)
                            eLocal.Heist.DiamondCasino.Finish.Step3:Set(80)
                            eLocal.Heist.DiamondCasino.Finish.Step4:Set(10000000)
                            eLocal.Heist.DiamondCasino.Finish.Step5:Set(99999)
                            eLocal.Heist.DiamondCasino.Finish.Step6:Set(99999)
                        else
                            eLocal.Heist.DiamondCasino.Finish.Step2:Set(5)
                            eLocal.Heist.DiamondCasino.Finish.Step3:Set(80)
                            eLocal.Heist.DiamondCasino.Finish.Step4:Set(10000000)
                            eLocal.Heist.DiamondCasino.Finish.Step5:Set(99999)
                            eLocal.Heist.DiamondCasino.Finish.Step6:Set(99999)
                        end

                        SilentLogger.LogInfo("[Instant Finish (Diamond Casino)] Heist should've been finished. Method used: Old ツ")
                    end
                },

                FingerprintHack = {
                    hash = J("SN_DiamondCasino_FingerprintHack"),
                    name = "Bypass Fingerprint Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the fingerprint hacking process.",
                    func = function()
                        eLocal.Heist.DiamondCasino.Bypass.FingerprintHack:Set(5)
                        SilentLogger.LogInfo("[Bypass Fingerprint Hack (Diamond Casino)] Hacking process should've been skipped ツ")
                    end
                },

                KeypadHack = {
                    hash = J("SN_DiamondCasino_KeypadHack"),
                    name = "Bypass Keypad Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the keypad hacking process.",
                    func = function()
                        eLocal.Heist.DiamondCasino.Bypass.KeypadHack:Set(5)
                        SilentLogger.LogInfo("[Bypass Keypad Hack (Diamond Casino)] Hacking process should've been skipped ツ")
                    end
                },

                VaultDoorDrill = {
                    hash = J("SN_DiamondCasino_VaultDoorDrill"),
                    name = "Bypass Vault Door Drill",
                    type = eFeatureType.Button,
                    desc = "Skips the vault door drilling process.",
                    func = function()
                        eLocal.Heist.DiamondCasino.Bypass.VaultDrill1:Set(eLocal.Heist.DiamondCasino.Bypass.VaultDrill2:Get())
                        SilentLogger.LogInfo("[Bypass Vault Door Drill (Diamond Casino)] Drilling process should've been skipped ツ")
                    end
                },

                Autograbber = {
                    hash = J("SN_DiamondCasino_Autograbber"),
                    name = "Autograbber",
                    type = eFeatureType.Toggle,
                    desc = "Grabs cash/gold/diamonds automatically. Might be slower than manually.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            if eLocal.Heist.DiamondCasino.Autograbber.Grab:Get() == 3 then
                                eLocal.Heist.DiamondCasino.Autograbber.Grab:Set(4)
                            elseif eLocal.Heist.DiamondCasino.Autograbber.Grab:Get() == 4 then
                                eLocal.Heist.DiamondCasino.Autograbber.Speed:Set(2.0)
                            end

                            if not loggedDiamondAuto then
                                SilentLogger.LogInfo("[Autograbber (Diamond Casino)] Autograbber should've been enabled ツ")
                                loggedDiamondAuto = true
                            end
                        else
                            SilentLogger.LogInfo("[Autograbber (Diamond Casino)] Autograbber should've been disabled ツ")
                            loggedDiamondAuto = false
                        end
                    end
                },

                Cooldown = {
                    hash = J("SN_DiamondCasino_Cooldown"),
                    name = "Kill Cooldown",
                    type = eFeatureType.Button,
                    desc = "Skips the heist's cooldown. Doesn't skip the cooldown between transactions (20 min). Use outside of your arcade.",
                    func = function()
                        eStat.MPX_H3_COMPLETEDPOSIX:Set(-1)
                        eStat.MPPLY_H3_COOLDOWN:Set(-1)
                        SilentLogger.LogInfo("[Kill Cooldown (Diamond Casino)] Cooldown should've been killed ツ")
                    end
                },

                Setup = {
                    hash = J("SN_DiamondCasino_Setup"),
                    name = "Skip Setup",
                    type = eFeatureType.Button,
                    desc = "Skips the setup mission for your Arcade. Change the session to apply.",
                    func = function()
                        ePackedBool.Business.Arcade.Setup:Set(true)
                        SilentLogger.LogInfo("[Skip Setup (Diamond Casino)] Setups should've been skipped. Don't forget to change the session ツ")
                    end
                }
            },

            Cuts = {
                Team = {
                    hash = J("SN_DiamondCasino_Team"),
                    name = "Team",
                    type = eFeatureType.Combo,
                    desc = "Select your number of players.",
                    list = eTable.Heist.Generic.Team,
                    func = function(ftr)
                        local list = eTable.Heist.Generic.Team
                        local team = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Team (Diamond Casino)] Selected team size: %s ツ", list:GetName(team)))
                    end
                },

                Presets = {
                    hash = J("SN_DiamondCasino_Presets"),
                    name = "Presets",
                    type = eFeatureType.Combo,
                    desc = "Select one of the ready-made presets.",
                    list = eTable.Heist.DiamondCasino.Presets,
                    func = function()
                        Helper.SetDiamondMaxPayout()
                        Script.Yield()
                    end
                },

                Crew = {
                    hash = J("SN_DiamondCasino_Crew"),
                    name = "Remove Crew Cuts",
                    type = eFeatureType.Toggle,
                    desc = "Removes crew cuts and Lester's cut. Should be used with «Instant Finish».",
                    func = function(ftr)
                        local function SetOrResetCuts(tbl, bool)
                            for _, v in pairs(tbl) do
                                if type(v) == "table" and v.Set then
                                    if bool then
                                        v:Set(0)
                                    else
                                        v:Reset()
                                    end
                                elseif type(v) == "table" then
                                    SetOrResetCuts(v, bool)
                                end
                            end
                        end

                        SetOrResetCuts(eTunable.Heist.DiamondCasino.Cut, ftr:IsToggled())

                        if ftr:IsToggled() then
                            if not loggedDiamondCrew then
                                SilentLogger.LogInfo("[Remove Crew Cuts (Diamond Casino)] Crew cuts should've been removed ツ")
                                loggedDiamondCrew = true
                            end
                        else
                            SilentLogger.LogInfo("[Remove Crew Cuts (Diamond Casino)] Crew cuts should've been reset ツ")
                            loggedDiamondCrew = false
                        end
                    end
                },

                Player1 = {
                    hash = J("SN_DiamondCasino_Player1"),
                    name = "Player 1",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 1.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 1 (Diamond Casino)] Player 1 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player2 = {
                    hash = J("SN_DiamondCasino_Player2"),
                    name = "Player 2",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 2.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 2 (Diamond Casino)] Player 2 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player3 = {
                    hash = J("SN_DiamondCasino_Player3"),
                    name = "Player 3",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 3.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 3 (Diamond Casino)] Player 3 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player4 = {
                    hash = J("SN_DiamondCasino_Player4"),
                    name = "Player 4",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 4.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 4 (Diamond Casino)] Player 4 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Apply = {
                    hash = J("SN_DiamondCasino_Apply"),
                    name = "Apply Cuts",
                    type = eFeatureType.Button,
                    desc = "Applies the selected cuts for players. If solo, apply near the planning board.",
                    func = function(cuts)
                        for i = 1, 4 do
                            eGlobal.Heist.DiamondCasino.Cut[F("Player%d", i)]:Set(cuts[i])
                        end
                        SilentLogger.LogInfo("[Apply Cuts (Diamond Casino)] Cuts should've been applied ツ")
                    end
                }
            },

            Presets = {
                File = {
                    hash = J("SN_DiamondCasino_File"),
                    name = "File",
                    type = eFeatureType.Combo,
                    desc = "Select the desired preset.",
                    list = eTable.Heist.DiamondCasino.Files,
                    func = function(ftr)
                        local list  = eTable.Heist.DiamondCasino.Files
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[File (Diamond Casino)] Selected heist preset: %s ツ", (list:GetName(index) == "") and "Empty" or list:GetName(index)))
                    end
                },

                Load = {
                    hash = J("SN_DiamondCasino_Load"),
                    name = "Load",
                    type = eFeatureType.Button,
                    desc = "Loads the selected preset.",
                    func = function(file)
                        local path = F("%s\\%s.json", DIAMOND_DIR, file)

                        if FileMgr.DoesFileExist(path) then
                            local preps = Json.DecodeFromFile(path)
                            Helper.ApplyDiamondPreset(preps)
                            SilentLogger.LogInfo(F("[Load (Diamond Casino)] Preset «%s» should've been loaded ツ", file))
                            return
                        end

                        SilentLogger.LogError(F("[Load (Diamond Casino)] Preset «%s» doesn't exist ツ", (file == "") and "Empty" or file))
                    end
                },

                Remove = {
                    hash = J("SN_DiamondCasino_Remove"),
                    name = "Remove",
                    type = eFeatureType.Button,
                    desc = "Removes the selected preset.",
                    func = function(file)
                        local path = F("%s\\%s.json", DIAMOND_DIR, file)

                        if FileMgr.DoesFileExist(path) then
                            FileMgr.DeleteFile(path)
                            Helper.RefreshFiles()
                            SilentLogger.LogInfo(F("[Remove (Diamond Casino)] Preset «%s» should've been removed ツ", file))
                            return
                        end

                        SilentLogger.LogError(F("[Remove (Diamond Casino)] Preset «%s» doesn't exist ツ", (file == "") and "Empty" or file))
                    end
                },

                Refresh = {
                    hash = J("SN_DiamondCasino_Refresh"),
                    name = "Refresh",
                    type = eFeatureType.Button,
                    desc = "Refreshes the list of presets.",
                    func = function()
                        Helper.RefreshFiles()
                        SilentLogger.LogInfo("[Refresh (Diamond Casino)] Heist presets should've been refreshed ツ")
                    end
                },

                Name = {
                    hash = J("SN_DiamondCasino_Name"),
                    name = "QuickPreset",
                    type = eFeatureType.InputText,
                    desc = "Input the desired preset name."
                },

                Save = {
                    hash = J("SN_DiamondCasino_Save"),
                    name = "Save",
                    type = eFeatureType.Button,
                    desc = "Saves the current preparations to the file.",
                    func = function(file, preps)
                        local path = F("%s\\%s.json", DIAMOND_DIR, file)
                        FileMgr.CreateHeistPresetsDirs()
                        Json.EncodeToFile(path, preps)
                        Helper.RefreshFiles()
                        SilentLogger.LogInfo(F("[Save (Diamond Casino)] Preset «%s» should've been saved ツ", file))
                    end
                },

                Copy = {
                    hash = J("SN_DiamondCasino_Copy"),
                    name = "Copy Folder Path",
                    type = eFeatureType.Button,
                    desc = "Copies the presets folder path to the clipboard.",
                    func = function()
                        FileMgr.CreateHeistPresetsDirs()
                        ImGui.SetClipboardText(DIAMOND_DIR)
                        SilentLogger.LogInfo("[Copy Folder Path (Diamond Casino)] Presets folder path should've been copied ツ")
                    end
                }
            }
        },

        Doomsday = {
            Preps = {
                Act = {
                    hash = J("SN_Doomsday_Act"),
                    name = "Act",
                    type = eFeatureType.Combo,
                    desc = "Select the desired doomsday act.",
                    list = eTable.Heist.Doomsday.Acts,
                    func = function(ftr)
                        local list  = eTable.Heist.Doomsday.Acts
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Act (Doomsday)] Selected act: %s ツ", list:GetName(index)))
                    end
                },

                Complete = {
                    hash = J("SN_Doomsday_Complete"),
                    name = "Apply & Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Applies all changes and completes all preparations. Also, reloads the planning screen.",
                    func = function(act)
                        local acts = {
                            [1] = { 503,   -229383 },
                            [2] = { 240,   -229378 },
                            [3] = { 16368, -229380 }
                        }

                        eStat.MPX_GANGOPS_FLOW_MISSION_PROG:Set(acts[act][1])
                        eStat.MPX_GANGOPS_HEIST_STATUS:Set(acts[act][2])
                        eStat.MPX_GANGOPS_FLOW_NOTIFICATIONS:Set(1557)
                        eLocal.Heist.Doomsday.Reload:Set(6)
                        SilentLogger.LogInfo(F("[Apply & Complete Preps (Doomsday)] Preps should've been completed ツ", act))
                    end
                },

                Reset = {
                    hash = J("SN_Doomsday_Reset"),
                    name = "Reset Preps",
                    type = eFeatureType.Button,
                    desc = "Resets all preparations. Also, reloads the planning screen.",
                    func = function()
                        eStat.MPX_GANGOPS_FLOW_MISSION_PROG:Set(503)
                        eStat.MPX_GANGOPS_HEIST_STATUS:Set(0)
                        eStat.MPX_GANGOPS_FLOW_NOTIFICATIONS:Set(1557)
                        eLocal.Heist.Doomsday.Reload:Set(6)
                        SilentLogger.LogInfo("[Reset Preps (Doomsday)] Preps should've been reset ツ")
                    end
                },

                Reload = {
                    hash = J("SN_Doomsday_Reload"),
                    name = "Reload Screen",
                    type = eFeatureType.Button,
                    desc = "Reloads the planning screen.",
                    func = function()
                        eLocal.Heist.Doomsday.Reload:Set(6)
                        SilentLogger.LogInfo("[Reload Screen (Doomsday)] Screen should've been reloaded ツ")
                    end
                }
            },

            Misc = {
                Force = {
                    hash = J("SN_Doomsday_Force"),
                    name = "Force Ready",
                    type = eFeatureType.Button,
                    desc = "Forces everyone to be «Ready».",
                    func = function()
                        GTA.ForceScriptHost(eScript.Heist.Doomsday)
                        Script.Yield(1000)

                        for i = 2, 4 do
                            eGlobal.Heist.Doomsday.Ready[F("Player%d", i)]:Set(1)
                        end

                        SilentLogger.LogInfo("[Force Ready (Doomsday)] Everyone should've been forced ready ツ")
                    end
                },

                Finish = {
                    hash = Utils.Joaat("SN_Doomsday_Finish"),
                    name = "Instant Finish",
                    type = eFeatureType.Button,
                    desc = "Finishes the heist instantly. Use after you can see the minimap.",
                    func = function()
                        if CONFIG.instant_finish.doomsday == 1 then
                            Helper.NewInstantFinishHeist()

                            SilentLogger.LogInfo("[Instant Finish (Doomsday)] Heist should've been finished. Method used: New ツ")
                            return
                        end

                        GTA.ForceScriptHost(eScript.Heist.Doomsday)
                        Script.Yield(1000)
                        eLocal.Heist.Doomsday.Finish.Step1:Set(12)
                        eLocal.Heist.Doomsday.Finish.Step2:Set(150)
                        eLocal.Heist.Doomsday.Finish.Step3:Set(99999)
                        eLocal.Heist.Doomsday.Finish.Step4:Set(99999)
                        eLocal.Heist.Doomsday.Finish.Step5:Set(80)
                        SilentLogger.LogInfo("[Instant Finish (Doomsday)] Heist should've been finished. Method used: Old ツ")
                    end
                },

                DataHack = {
                    hash = J("SN_Doomsday_DataHack"),
                    name = "Bypass Data Breaches Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the hacking process of The Data Breaches heist.",
                    func = function()
                        eLocal.Heist.Doomsday.Bypass.DataHack:Set(2)
                        SilentLogger.LogInfo("[Bypass Data Breaches Hack (Doomsday)] Hacking process should've been skipped ツ")
                    end
                },

                DoomsdayHack = {
                    hash = J("SN_Doomsday_DoomsdayHack"),
                    name = "Bypass Dooms. Scen. Hack",
                    type = eFeatureType.Button,
                    desc = "Skips the hacking process of The Doomsday Scenario heist.",
                    func = function()
                        eLocal.Heist.Doomsday.Bypass.DoomsdayHack:Set(3)
                        SilentLogger.LogInfo("[Bypass Doomsday Scenario Hack (Doomsday)] Hacking process should've been skipped ツ")
                    end
                }
            },

            Cuts = {
                Team = {
                    hash = J("SN_Doomsday_Team"),
                    name = "Team",
                    type = eFeatureType.Combo,
                    desc = "Select your number of players.",
                    list = eTable.Heist.Generic.Team,
                    func = function(ftr)
                        local list = eTable.Heist.Generic.Team
                        local team = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Team (Doomsday)] Selected team size: %s ツ", list:GetName(team)))
                    end
                },

                Presets = {
                    hash = J("SN_Doomsday_Presets"),
                    name = "Presets",
                    type = eFeatureType.Combo,
                    desc = "Select one of the ready-made presets. 2.55mil Payout only works if you've set the Act through the script.",
                    list = eTable.Heist.Doomsday.Presets,
                    func = function()
                        Helper.SetDoomsdayMaxPayout()
                        Script.Yield()
                    end
                },

                Player1 = {
                    hash = J("SN_Doomsday_Player1"),
                    name = "Player 1",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 1.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 1 (Doomsday)] Player 1 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player2 = {
                    hash = J("SN_Doomsday_Player2"),
                    name = "Player 2",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 2.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 2 (Doomsday)] Player 2 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player3 = {
                    hash = J("SN_Doomsday_Player3"),
                    name = "Player 3",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 3.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 3 (Doomsday)] Player 3 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Player4 = {
                    hash = J("SN_Doomsday_Player4"),
                    name = "Player 4",
                    type = eFeatureType.InputInt,
                    desc = "Select the cut for Player 4.",
                    defv = 0,
                    lims = { 0, 999 },
                    step = 1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Player 4 (Doomsday)] Player 4 cut should've been changed. Don't forget to apply ツ")
                    end
                },

                Apply = {
                    hash = J("SN_Doomsday_Apply"),
                    name = "Apply Cuts",
                    type = eFeatureType.Button,
                    desc = "Applies the selected cuts for players.",
                    func = function(cuts)
                        for i = 1, 4 do
                            eGlobal.Heist.Doomsday.Cut[F("Player%d", i)]:Set(cuts[i])
                        end
                        SilentLogger.LogInfo("[Apply Cuts (Doomsday)] Cuts should've been applied ツ")
                    end
                }
            }
        },

        SalvageYard = {
            Slot1 = {
                Robbery = {
                    hash = J("SN_SalvageYard_RobberySlot1"),
                    name = "Robbery",
                    type = eFeatureType.Combo,
                    desc = "Select the desired robbery type for slot 1.",
                    list = eTable.Heist.SalvageYard.Robberies,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Robberies
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Robbery (Salvage Yard)] Selected slot 1 robbery: %s ツ", list:GetName(index)))
                    end
                },

                Vehicle = {
                    hash = J("SN_SalvageYard_VehicleSlot1"),
                    name = "Vehicle",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicle type for slot 1.",
                    list = eTable.Heist.SalvageYard.Vehicles,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Vehicles
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Vehicle (Salvage Yard)] Selected slot 1 vehicle: %s ツ", list:GetName(index)))
                    end
                },

                Modification = {
                    hash = J("SN_SalvageYard_ModificationSlot1"),
                    name = "Modification",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicle modification for slot 1.",
                    list = eTable.Heist.SalvageYard.Modifications,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Modifications
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Modification (Salvage Yard)] Selected slot 1 modification: %s ツ", list:GetName(index)))
                    end
                },

                Keep = {
                    hash = J("SN_SalvageYard_KeepSlot1"),
                    name = "Status",
                    type = eFeatureType.Combo,
                    desc = "Select whether you can keep the vehicle for slot 1.",
                    list = eTable.Heist.SalvageYard.Keeps,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Keeps
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Status (Salvage Yard)] Selected slot 1 keep status: %s ツ", list:GetName(index)))
                    end
                },

                Apply = {
                    hash = J("SN_SalvageYard_ApplySlot1"),
                    name = "Apply Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes for the slot 1. Also, reloads the planning screen. Use before you start the preparation.",
                    func = function(robbery, vehicle, modification, keep)
                        eGlobal.Heist.SalvageYard.Robbery.Slot1.Type:Set(robbery)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot1.Type:Set(vehicle + modification * 100)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot1.CanKeep:Set(keep)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply Changes (Salvage Yard)] Slot 1 changes should've been applied ツ")
                    end
                }
            },

            Slot2 = {
                Robbery = {
                    hash = J("SN_SalvageYard_RobberySlot2"),
                    name = "Robbery",
                    type = eFeatureType.Combo,
                    desc = "Select the desired robbery type for slot 2.",
                    list = eTable.Heist.SalvageYard.Robberies,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Robberies
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Robbery (Salvage Yard)] Selected slot 2 robbery: %s ツ", list:GetName(index)))
                    end
                },

                Vehicle = {
                    hash = J("SN_SalvageYard_VehicleSlot2"),
                    name = "Vehicle",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicle type for slot 2.",
                    list = eTable.Heist.SalvageYard.Vehicles,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Vehicles
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Vehicle (Salvage Yard)] Selected slot 2 vehicle: %s ツ", list:GetName(index)))
                    end
                },

                Modification = {
                    hash = J("SN_SalvageYard_ModificationSlot2"),
                    name = "Modification",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicle modification for slot 2.",
                    list = eTable.Heist.SalvageYard.Modifications,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Modifications
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Modification (Salvage Yard)] Selected slot 2 modification: %s ツ", list:GetName(index)))
                    end
                },

                Keep = {
                    hash = J("SN_SalvageYard_KeepSlot2"),
                    name = "Status",
                    type = eFeatureType.Combo,
                    desc = "Select whether you can keep the vehicle for slot 2.",
                    list = eTable.Heist.SalvageYard.Keeps,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Keeps
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Status (Salvage Yard)] Selected slot 2 keep status: %s ツ", list:GetName(index)))
                    end
                },

                Apply = {
                    hash = J("SN_SalvageYard_ApplySlot2"),
                    name = "Apply Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes for the slot 2. Also, reloads the planning screen. Use before you start the preparation.",
                    func = function(robbery, vehicle, modification, keep)
                        eGlobal.Heist.SalvageYard.Robbery.Slot2.Type:Set(robbery)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot2.Type:Set(vehicle + modification * 100)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot2.CanKeep:Set(keep)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply Changes (Salvage Yard)] Slot 2 changes should've been applied ツ")
                    end
                }
            },

            Slot3 = {
                Robbery = {
                    hash = J("SN_SalvageYard_RobberySlot3"),
                    name = "Robbery",
                    type = eFeatureType.Combo,
                    desc = "Select the desired robbery type for slot 3.",
                    list = eTable.Heist.SalvageYard.Robberies,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Robberies
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Robbery (Salvage Yard)] Selected slot 3 robbery: %s ツ", list:GetName(index)))
                    end
                },

                Vehicle = {
                    hash = J("SN_SalvageYard_VehicleSlot3"),
                    name = "Vehicle",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicle type for slot 3.",
                    list = eTable.Heist.SalvageYard.Vehicles,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Vehicles
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Vehicle (Salvage Yard)] Selected slot 3 vehicle: %s ツ", list:GetName(index)))
                    end
                },

                Modification = {
                    hash = J("SN_SalvageYard_ModificationSlot3"),
                    name = "Modification",
                    type = eFeatureType.Combo,
                    desc = "Select the desired vehicle modification for slot 3.",
                    list = eTable.Heist.SalvageYard.Modifications,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Modifications
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Modification (Salvage Yard)] Selected slot 3 modification: %s ツ", list:GetName(index)))
                    end
                },

                Keep = {
                    hash = J("SN_SalvageYard_KeepSlot3"),
                    name = "Status",
                    type = eFeatureType.Combo,
                    desc = "Select whether you can keep the vehicle for slot 3.",
                    list = eTable.Heist.SalvageYard.Keeps,
                    func = function(ftr)
                        local list  = eTable.Heist.SalvageYard.Keeps
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Status (Salvage Yard)] Selected slot 3 keep status: %s ツ", list:GetName(index)))
                    end
                },

                Apply = {
                    hash = J("SN_SalvageYard_ApplySlot3"),
                    name = "Apply Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes for the slot 3. Also, reloads the planning screen. Use before you start the preparation.",
                    func = function(robbery, vehicle, modification, keep)
                        eGlobal.Heist.SalvageYard.Robbery.Slot3.Type:Set(robbery)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot3.Type:Set(vehicle + modification * 100)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot3.CanKeep:Set(keep)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply Changes (Salvage Yard)] Slot 3 changes should've been applied ツ")
                    end
                }
            },

            Preps = {
                Apply = {
                    hash = J("SN_SalvageYard_ApplyAll"),
                    name = "Apply All Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes. Also, reloads the planning screen. Use before you start the preparation.",
                    func = function(robbery1, vehicle1, mod1, keep1, robbery2, vehicle2, mod2, keep2, robbery3, vehicle3, mod3, keep3)
                        eGlobal.Heist.SalvageYard.Robbery.Slot1.Type:Set(robbery1)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot1.Type:Set(vehicle1 + mod1 * 100)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot1.CanKeep:Set(keep1)
                        eGlobal.Heist.SalvageYard.Robbery.Slot2.Type:Set(robbery2)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot2.Type:Set(vehicle2 + mod2 * 100)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot2.CanKeep:Set(keep2)
                        eGlobal.Heist.SalvageYard.Robbery.Slot3.Type:Set(robbery3)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot3.Type:Set(vehicle3 + mod3 * 100)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot3.CanKeep:Set(keep3)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply All Changes (Salvage Yard)] Changes should've been applied ツ")
                    end
                },

                Complete = {
                    hash = J("SN_SalvageYard_Complete"),
                    name = "Complete Preps",
                    type = eFeatureType.Button,
                    desc = "Completes all preparations. Also, reloads the planning screen.",
                    func = function()
                        eStat.MPX_SALV23_GEN_BS:Set(-1)
                        eStat.MPX_SALV23_SCOPE_BS:Set(-1)
                        eStat.MPX_SALV23_FM_PROG:Set(-1)
                        eStat.MPX_SALV23_INST_PROG:Set(-1)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Complete Preps (Salvage Yard)] Preps should've been completed ツ")
                    end
                },

                Reset = {
                    hash = J("SN_SalvageYard_Reset"),
                    name = "Reset Preps",
                    type = eFeatureType.Button,
                    desc = "Resets all preparations. Also, reloads the planning screen.",
                    func = function()
                        eStat.MPX_SALV23_GEN_BS:Set(0)
                        eStat.MPX_SALV23_SCOPE_BS:Set(0)
                        eStat.MPX_SALV23_FM_PROG:Set(0)
                        eStat.MPX_SALV23_INST_PROG:Set(0)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Reset Preps (Salvage Yard)] Preps should've been reset ツ")
                    end
                },

                Reload = {
                    hash = J("SN_SalvageYard_Reload"),
                    name = "Reload Screen",
                    type = eFeatureType.Button,
                    desc = "Reloads the planning screen.",
                    func = function()
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Reload Screen (Salvage Yard)] Screen should've been reloaded ツ")
                    end
                }
            },

            Misc = {
                Cooldown = {
                    Kill = {
                        hash = J("SN_SalvageYard_Cooldown"),
                        name = "Kill Cooldowns",
                        type = eFeatureType.Button,
                        desc = "Skips the heist's cooldowns. Use outside of your salvage yard.",
                        func = function()
                            eTunable.Heist.SalvageYard.Cooldown.Robbery:Set(0)
                            eTunable.Heist.SalvageYard.Cooldown.Cfr:Set(0)
                            SilentLogger.LogInfo("[Kill Cooldowns (Salvage Yard)] Cooldowns should've been killed ツ")
                        end
                    },

                    Skip = {
                        hash = J("SN_SalvageYard_Weekly"),
                        name = "Skip Weekly Cooldown",
                        type = eFeatureType.Button,
                        desc = "Skips the heist's weekly cooldown. Also, reloads the planning screen.",
                        func = function()
                            eTunable.Heist.SalvageYard.Cooldown.Weekly:Set(eStat.MPX_SALV23_WEEK_SYNC:Get() + 1)
                            eLocal.Heist.SalvageYard.Reload:Set(2)
                            SilentLogger.LogInfo("[Skip Weekly Cooldown (Salvage Yard)] Cooldown should've been skipped ツ")
                        end
                    }
                },

                Availability = {
                    Slot1 = {
                        hash = J("SN_SalvageYard_AvailableSlot1"),
                        name = "Make Slot 1 Available",
                        type = eFeatureType.Button,
                        desc = "Makes the slot 1 «Available». Also, reloads the planning screen.",
                        func = function()
                            eStat.MPX_SALV23_VEHROB_STATUS0:Set(0)
                            eLocal.Heist.SalvageYard.Reload:Set(2)
                            SilentLogger.LogInfo("[Make Slot 1 Available (Salvage Yard)] Slot 1 should've been made «Available» ツ")
                        end
                    },

                    Slot2 = {
                        hash = J("SN_SalvageYard_AvailableSlot2"),
                        name = "Make Slot 2 Available",
                        type = eFeatureType.Button,
                        desc = "Makes the slot 2 «Available». Also, reloads the planning screen.",
                        func = function()
                            eStat.MPX_SALV23_VEHROB_STATUS1:Set(0)
                            eLocal.Heist.SalvageYard.Reload:Set(2)
                            SilentLogger.LogInfo("[Make Slot 2 Available (Salvage Yard)] Slot 2 should've been made «Available» ツ")
                        end
                    },

                    Slot3 = {
                        hash = J("SN_SalvageYard_AvailableSlot3"),
                        name = "Make Slot 3 Available",
                        type = eFeatureType.Button,
                        desc = "Makes the slot 3 «Available». Also, reloads the planning screen.",
                        func = function()
                            eStat.MPX_SALV23_VEHROB_STATUS2:Set(0)
                            eLocal.Heist.SalvageYard.Reload:Set(2)
                            SilentLogger.LogInfo("[Make Slot 3 Available (Salvage Yard)] Slot 3 should've been made «Available» ツ")
                        end
                    }
                },

                Free = {
                    Setup = {
                        hash = J("SN_SalvageYard_Setup"),
                        name = "Free Setup",
                        type = eFeatureType.Toggle,
                        desc = "Allows setuping the heist for free.",
                        func = function(ftr)
                            eTunable.Heist.SalvageYard.Robbery.SetupPrice:Set((ftr:IsToggled()) and 0 or 20000)

                            if ftr:IsToggled() then
                                if not loggedSalvageSetup then
                                    SilentLogger.LogInfo("[Free Setup (Salvage Yard)] Setup price should've been made free ツ")
                                    loggedSalvageSetup = true
                                end
                            else
                                SilentLogger.LogInfo("[Free Setup (Salvage Yard)] Setup price should've been made paid ツ")
                                loggedSalvageSetup = false
                            end
                        end
                    },

                    Claim = {
                        hash = J("SN_SalvageYard_Claim"),
                        name = "Free Claim",
                        type = eFeatureType.Toggle,
                        desc = "Allows claiming the vehicles for free.",
                        func = function(ftr)
                            eTunable.Heist.SalvageYard.Vehicle.ClaimPrice.Standard:Set((ftr:IsToggled()) and 0 or 20000)
                            eTunable.Heist.SalvageYard.Vehicle.ClaimPrice.Discounted:Set((ftr:IsToggled()) and 0 or 10000)

                            if ftr:IsToggled() then
                                if not loggedSalvageClaim then
                                    SilentLogger.LogInfo("[Free Claim (Salvage Yard)] Claim price should've been made free ツ")
                                    loggedSalvageClaim = true
                                end
                            else
                                SilentLogger.LogInfo("[Free Claim (Salvage Yard)] Claim price should've been made paid ツ")
                                loggedSalvageClaim = false
                            end
                        end
                    }
                }
            },

            Payout = {
                Salvage = {
                    hash = J("SN_SalvageYard_Salvage"),
                    name = "Salvage Value Multiplier",
                    type = eFeatureType.InputFloat,
                    desc = "Select the desired salvage value multiplier.",
                    defv = eGlobal.Heist.SalvageYard.Vehicle.SalvageValueMultiplier:Get(),
                    lims = { 0.0, 5.0 },
                    step = 0.1,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Salvage Value Multiplier (Salvage Yard)] Multiplier should've been changed ツ")
                    end
                },

                Slot1 = {
                    hash = J("SN_SalvageYard_SelectSlot1"),
                    name = "Sell Value Slot 1",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sell value for the vehicle in slot 1.",
                    defv = eGlobal.Heist.SalvageYard.Vehicle.Slot1.Value:Get(),
                    lims = { 0, 2100000 },
                    step = 100000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Value Slot 1 (Salvage Yard)] Slot 1 sell value should've been changed ツ")
                    end
                },

                Slot2 = {
                    hash = J("SN_SalvageYard_SelectSlot2"),
                    name = "Sell Value Slot 2",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sell value for the vehicle in slot 2.",
                    defv = eGlobal.Heist.SalvageYard.Vehicle.Slot2.Value:Get(),
                    lims = { 0, 2100000 },
                    step = 100000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Value Slot 2 (Salvage Yard)] Slot 2 sell value should've been changed ツ")
                    end
                },

                Slot3 = {
                    hash = J("SN_SalvageYard_SelectSlot3"),
                    name = "Sell Value Slot 3",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sell value for the vehicle in slot 3.",
                    defv = eGlobal.Heist.SalvageYard.Vehicle.Slot3.Value:Get(),
                    lims = { 0, 2100000 },
                    step = 100000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Value Slot 3 (Salvage Yard)] Slot 3 sell value should've been changed ツ")
                    end
                },

                Apply = {
                    hash = J("SN_SalvageYard_Apply"),
                    name = "Apply Sell Values",
                    type = eFeatureType.Button,
                    desc = "Applies the selected sell values for the vehicles. Also, reloads the planning screen. Use before you start the preparation.",
                    func = function(salvageMultiplier, sellValue1, sellValue2, sellValue3)
                        eGlobal.Heist.SalvageYard.Vehicle.SalvageValueMultiplier:Set(salvageMultiplier)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot1.Value:Set(sellValue1)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot2.Value:Set(sellValue2)
                        eGlobal.Heist.SalvageYard.Vehicle.Slot3.Value:Set(sellValue3)
                        eLocal.Heist.SalvageYard.Reload:Set(2)
                        SilentLogger.LogInfo("[Apply Sell Values (Salvage Yard)] Sell values should've been applied ツ")
                    end
                }
            }
        }
    },

    Business = {
        Bunker = {
            Sale = {
                Price = {
                    hash = J("SN_Bunker_Price"),
                    name = "Maximize Price",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Applies the maximum price for your stock.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            if not GTA.IsInSessionAlone() then
                                GTA.EmptySession()
                            end

                            if eStat.MPX_PRODTOTALFORFACTORY5:Get() == 0 then
                                eGlobal.Business.Supplies.Bunker:Set(1)
                                Script.Yield(1000)
                                eGlobal.Business.Bunker.Production.Trigger1:Set(0)
                                eGlobal.Business.Bunker.Production.Trigger2:Set(true)
                            end

                            eTunable.Business.Bunker.Product.Value:Set(math.floor((2500000 / 1.5) / eStat.MPX_PRODTOTALFORFACTORY5:Get()))
                            eTunable.Business.Bunker.Product.StaffUpgraded:Set(0)
                            eTunable.Business.Bunker.Product.EquipmentUpgraded:Set(0)

                            if not loggedBunkerPrice then
                                SilentLogger.LogInfo("[Maximize Price (Bunker)] Price should've been maximized ツ")
                                loggedBunkerPrice = true
                            end
                        else
                            eTunable.Business.Bunker.Product.Value:Reset()
                            eTunable.Business.Bunker.Product.StaffUpgraded:Reset()
                            eTunable.Business.Bunker.Product.EquipmentUpgraded:Reset()
                            SilentLogger.LogInfo("[Maximize Price (Bunker)] Price should've been reset ツ")
                            loggedBunkerPrice = false
                        end
                    end
                },

                NoXp = {
                    hash = J("SN_Bunker_NoXp"),
                    name = "No XP Gain",
                    type = eFeatureType.Toggle,
                    desc = "Disables the xp gain for sell missions.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[No XP Gain (Bunker)] XP gain should've been %s ツ", (ftr:IsToggled()) and "disabled" or "enabled"))
                    end
                },

                Sell = {
                    hash = J("SN_Bunker_Sell"),
                    name = "Instant Sell",
                    type = eFeatureType.Button,
                    desc = "Finishes the sell mission instantly. Use after you can see the minimap.",
                    func = function(bool)
                        eGlobal.World.Multiplier.Xp:Set((bool) and 0.0 or 1.0)
                        eLocal.Business.Bunker.Sell.Finish:Set(0)
                        SilentLogger.LogInfo("[Instant Sell (Bunker)] Sell mission should've been finished ツ")
                    end
                }
            },

            Misc = {
                Open = {
                    hash = J("SN_Bunker_Open"),
                    name = "Open Laptop",
                    type = eFeatureType.Button,
                    desc = "Opens the Bunker's laptop screen.",
                    func = function()
                        GTA.StartScript(eScript.Business.Bunker.Laptop)
                        SilentLogger.LogInfo("[Open Laptop (Bunker)] Laptop screen should've been opened ツ")
                    end
                },

                Supply = {
                    hash = J("SN_Bunker_Supply"),
                    name = "Get Supplies",
                    type = eFeatureType.Button,
                    desc = "Gets supplies for your Bunker.",
                    func = function()
                        eGlobal.Business.Supplies.Bunker:Set(1)
                        SilentLogger.LogInfo("[Get Supplies (Bunker)] Supplies should've been received ツ")
                    end
                },

                Trigger = {
                    hash = J("SN_Bunker_Trigger"),
                    name = "Trigger Production",
                    type = eFeatureType.Button,
                    desc = "Triggers production of your stock.",
                    func = function()
                        if not GTA.IsScriptRunning(eScript.Business.Bunker.Laptop) then
                            eGlobal.Business.Bunker.Production.Trigger1:Set(0)
                            eGlobal.Business.Bunker.Production.Trigger2:Set(true)
                            SilentLogger.LogInfo("[Trigger Production (Bunker)] Production should've been triggered ツ")
                        end
                    end
                },

                Supplier = {
                    hash = J("SN_Bunker_Supplier"),
                    name = "Turkish Supplier",
                    type = eFeatureType.Toggle,
                    desc = "Fills your Bunker stock. Also, gets supplies for your Bunker repeatedly.",
                    func = function(ftr)
                        if not GTA.IsScriptRunning(eScript.Business.Bunker.Laptop) then
                            if ftr:IsToggled() then
                                eGlobal.Business.Supplies.Bunker:Set(1)
                                eGlobal.Business.Bunker.Production.Trigger1:Set(0)
                                eGlobal.Business.Bunker.Production.Trigger2:Set(true)

                                if not loggedBunkerSupplier then
                                    SilentLogger.LogInfo("[Turkish Supplier (Bunker)] Supplier should've been enabled ツ")
                                    loggedBunkerSupplier = true
                                end

                                Script.Yield(1000)
                            else
                                eGlobal.Business.Supplies.Bunker:Set(0)
                                SilentLogger.LogInfo("[Turkish Supplier (Bunker)] Supplier should've been disabled ツ")
                            end

                        end
                    end
                }
            },

            Stats = {
                SellMade = {
                    hash = J("SN_Bunker_SellMade"),
                    name = "Sell Made",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales made.",
                    defv = eStat.MPX_LIFETIME_BKR_SEL_COMPLETBC5:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Made (Bunker)] Sales made should've been changed. Don't forget to apply ツ")
                    end
                },

                SellUndertaken = {
                    hash = J("SN_Bunker_Undertaken"),
                    name = "Sell Undertaken",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales undertaken.",
                    defv = eStat.MPX_LIFETIME_BKR_SEL_UNDERTABC5:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Undertaken (Bunker)] Sales undertaken should've been changed. Don't forget to apply ツ")
                    end
                },

                Earnings = {
                    hash = J("SN_Bunker_Earnings"),
                    name = "Earnings",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired earnings.",
                    defv = eStat.MPX_LIFETIME_BKR_SELL_EARNINGS5:Get(),
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Earnings (Bunker)] Earnings should've been changed. Don't forget to apply ツ")
                    end
                },

                NoSell = {
                    hash = J("SN_Bunker_NoSell"),
                    name = "Don't Apply Sell",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new sell missions or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Sell (Bunker)] Selected sell: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                NoEarnings = {
                    hash = J("SN_Bunker_NoEarnings"),
                    name = "Don't Apply Earnings",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new earnings or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Earnings (Bunker)] Selected earnings: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                Apply = {
                    hash = J("SN_Bunker_Apply"),
                    name = "Apply All Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes.",
                    func = function(bool1, bool2, sellMade, sellUndertaken, earnings)
                        if not bool1 then
                            eStat.MPX_LIFETIME_BKR_SEL_COMPLETBC5:Set(sellMade)
                            eStat.MPX_LIFETIME_BKR_SEL_UNDERTABC5:Set(sellUndertaken)
                            eStat.MPX_BUNKER_UNITS_MANUFAC:Set(sellMade * 100)
                        end
                        if not bool2 then
                            eStat.MPX_LIFETIME_BKR_SELL_EARNINGS5:Set(earnings)
                        end
                        SilentLogger.LogInfo("[Apply All Changes (Bunker)] Changes should've been applied ツ")
                    end
                }
            }
        },

        Hangar = {
            Sale = {
                Price = {
                    hash = J("SN_Hangar_Price"),
                    name = "Maximize Price",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Applies the maximum price for your cargo.",
                    func = function(ftr)
                        if not GTA.IsScriptRunning(eScript.Business.Hangar.Sell) then
                            if ftr:IsToggled() then
                                if not GTA.IsInSessionAlone() then
                                    GTA.EmptySession()
                                end

                                if eStat.MPX_HANGAR_CONTRABAND_TOTAL:Get() < 4 then
                                    ePackedBool.Business.Hangar.Cargo:Set(true)
                                    Script.Yield(1000)
                                end

                                eTunable.Business.Hangar.Price:Set(math.floor(4000000 / eStat.MPX_HANGAR_CONTRABAND_TOTAL:Get()))
                                eTunable.Business.Hangar.RonsCut:Set(0.0)

                                if not loggedHangarPrice then
                                    SilentLogger.LogInfo("[Maximize Price (Hangar)] Price should've been maximized ツ")
                                    loggedHangarPrice = true
                                end
                            else
                                eTunable.Business.Hangar.Price:Reset()
                                eTunable.Business.Hangar.RonsCut:Reset()
                                SilentLogger.LogInfo("[Maximize Price (Hangar)] Price should've been reset ツ")
                                loggedHangarPrice = false
                            end
                        end
                    end
                },

                NoXp = {
                    hash = J("SN_Hangar_NoXp"),
                    name = "No XP Gain",
                    type = eFeatureType.Toggle,
                    desc = "Disables the xp gain for sell missions.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[No XP Gain (Hangar)] XP gain should've been %s ツ", (ftr:IsToggled()) and "disabled" or "enabled"))
                    end
                },

                Sell = {
                    hash = J("SN_Hangar_Sell"),
                    name = "Instant Air Cargo Sell",
                    type = eFeatureType.Button,
                    desc = "Finishes the air cargo sell mission instantly. Use after you can see the minimap.",
                    func = function(bool)
                        eGlobal.World.Multiplier.Xp:Set((bool) and 0.0 or 1.0)
                        eLocal.Business.Hangar.Sell.Finish:Set(eLocal.Business.Hangar.Sell.Delivered:Get())
                        SilentLogger.LogInfo("[Instant Air Cargo Sell (Hangar)] Sell mission should've been finished ツ")
                    end
                }
            },

            Misc = {
                Open = {
                    hash = J("SN_Hangar_Open"),
                    name = "Open Laptop",
                    type = eFeatureType.Button,
                    desc = "Opens the Hangar's laptop screen.",
                    func = function()
                        GTA.StartScript(eScript.Business.Hangar.Laptop)
                        SilentLogger.LogInfo("[Open Laptop (Hangar)] Laptop screen should've been opened ツ")
                    end
                },

                Supply = {
                    hash = J("SN_Hangar_Supply"),
                    name = "Get Cargo",
                    type = eFeatureType.Button,
                    desc = "Gets cargo for your Hangar.",
                    func = function()
                        if not GTA.IsScriptRunning(eScript.Business.Hangar.Laptop) then
                            ePackedBool.Business.Hangar.Cargo:Set(true)
                            SilentLogger.LogInfo("[Get Cargo (Hangar)] Cargo should've been received ツ")
                        end
                    end
                },

                Supplier = {
                    hash = J("SN_Hangar_Supplier"),
                    name = "Turkish Supplier",
                    type = eFeatureType.Toggle,
                    desc = "Fills your Hangar stock repeatedly.",
                    func = function(ftr)
                        if not GTA.IsScriptRunning(eScript.Business.Hangar.Laptop) then
                            if ftr:IsToggled() then
                                ePackedBool.Business.Hangar.Cargo:Set(true)

                                if not loggedHangarSupplier then
                                    SilentLogger.LogInfo("[Turkish Supplier (Hangar)] Supplier should've been enabled ツ")
                                    loggedHangarSupplier = true
                                end

                                Script.Yield(1000)
                            else
                                ePackedBool.Business.Hangar.Cargo:Set(false)
                                SilentLogger.LogInfo("[Turkish Supplier (Hangar)] Supplier should've been disabled ツ")
                                loggedHangarSupplier = false
                            end
                        end
                    end
                },

                Cooldown = {
                    hash = J("SN_Hangar_Cooldown"),
                    name = "Kill Cooldowns",
                    type = eFeatureType.Toggle,
                    desc = "Skips almost all cooldowns.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            eTunable.Business.Hangar.Cooldown.Steal.Easy:Set(0)
                            eTunable.Business.Hangar.Cooldown.Steal.Medium:Set(0)
                            eTunable.Business.Hangar.Cooldown.Steal.Hard:Set(0)
                            eTunable.Business.Hangar.Cooldown.Steal.Additional:Set(0)
                            eTunable.Business.Hangar.Cooldown.Sell:Set(0)

                            if not loggedHangarCooldown then
                                SilentLogger.LogInfo("[Kill Cooldowns (Hangar)] Cooldowns should've been killed ツ")
                                loggedHangarCooldown = true
                            end
                        else
                            eTunable.Business.Hangar.Cooldown.Steal.Easy:Reset()
                            eTunable.Business.Hangar.Cooldown.Steal.Medium:Reset()
                            eTunable.Business.Hangar.Cooldown.Steal.Hard:Reset()
                            eTunable.Business.Hangar.Cooldown.Steal.Additional:Reset()
                            eTunable.Business.Hangar.Cooldown.Sell:Reset()
                            SilentLogger.LogInfo("[Kill Cooldowns (Hangar)] Cooldowns should've been reset ツ")
                            loggedHangarCooldown = false
                        end
                    end
                }
            },

            Stats = {
                BuyMade = {
                    hash = J("SN_Hangar_BuyMade"),
                    name = "Buy Made",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired buy made.",
                    defv = eStat.MPX_LFETIME_HANGAR_BUY_COMPLET:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Buy Made (Hangar)] Buy made should've been changed. Don't forget to apply ツ")
                    end
                },

                BuyUndertaken = {
                    hash = J("SN_Hangar_BuyUndertaken"),
                    name = "Buy Undertaken",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired buy undertaken.",
                    defv = eStat.MPX_LFETIME_HANGAR_BUY_UNDETAK:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Buy Undertaken (Hangar)] Buy undertaken should've been changed. Don't forget to apply ツ")
                    end
                },

                SellMade = {
                    hash = J("SN_Hangar_SellMade"),
                    name = "Sell Made",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales made.",
                    defv = eStat.MPX_LFETIME_HANGAR_SEL_COMPLET:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Made (Hangar)] Sales made should've been changed. Don't forget to apply ツ")
                    end
                },

                SellUndertaken = {
                    hash = J("SN_Hangar_SellUndertaken"),
                    name = "Sell Undertaken",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales undertaken.",
                    defv = eStat.MPX_LFETIME_HANGAR_SEL_UNDETAK:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Undertaken (Hangar)] Sales undertaken should've been changed. Don't forget to apply ツ")
                    end
                },

                Earnings = {
                    hash = J("SN_Hangar_Earnings"),
                    name = "Earnings",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired earnings.",
                    defv = eStat.MPX_LFETIME_HANGAR_EARNINGS:Get(),
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Earnings (Hangar)] Earnings should've been changed. Don't forget to apply ツ")
                    end
                },

                NoBuy = {
                    hash = J("SN_Hangar_NoBuy"),
                    name = "Don't Apply Buy",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new buy missions or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Buy (Hangar)] Selected buy: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                NoSell = {
                    hash = J("SN_Hangar_NoSell"),
                    name = "Don't Apply Sell",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new sell missions or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Sell (Hangar)] Selected sell: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                NoEarnings = {
                    hash = J("SN_Hangar_NoEarnings"),
                    name = "Don't Apply Earnings",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new earnings or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Earnings (Hangar)] Selected earnings: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                Apply = {
                    hash = J("SN_Hangar_Apply"),
                    name = "Apply All Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes.",
                    func = function(bool1, bool2, bool3, buyMade, buyUndertaken, sellMade, sellUndertaken, earnings)
                        if not bool1 then
                            eStat.MPX_LFETIME_HANGAR_BUY_COMPLET:Set(buyMade)
                            eStat.MPX_LFETIME_HANGAR_BUY_UNDETAK:Set(buyUndertaken)
                        end
                        if not bool2 then
                            eStat.MPX_LFETIME_HANGAR_SEL_COMPLET:Set(sellMade)
                            eStat.MPX_LFETIME_HANGAR_SEL_UNDETAK:Set(sellUndertaken)
                        end
                        if not bool3 then
                            eStat.MPX_LFETIME_HANGAR_EARNINGS:Set(earnings)
                        end
                        SilentLogger.LogInfo("[Apply All Changes (Hangar)] Changes should've been applied ツ")
                    end
                }
            }
        },

        Nightclub = {
            Sale = {
                Price = {
                    hash = J("SN_Nightclub_Price"),
                    name = "Maximize Price",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Applies the maximum price for goods. Don't sell «All Goods».",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            if not GTA.IsInSessionAlone() then
                                GTA.EmptySession()
                            end

                            local price = 4000000

                            eTunable.Business.Nightclub.Price.Weapons:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_1:Get()))
                            eTunable.Business.Nightclub.Price.Coke:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_2:Get()))
                            eTunable.Business.Nightclub.Price.Meth:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_3:Get()))
                            eTunable.Business.Nightclub.Price.Weed:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_4:Get()))
                            eTunable.Business.Nightclub.Price.Documents:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_5:Get()))
                            eTunable.Business.Nightclub.Price.Cash:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_6:Get()))
                            eTunable.Business.Nightclub.Price.Cargo:Set(math.floor(price / eStat.MPX_HUB_PROD_TOTAL_0:Get()))

                            if not loggedNightclubPrice then
                                SilentLogger.LogInfo("[Maximize Price (Nightclub)] Price should've been maximized ツ")
                                loggedNightclubPrice = true
                            end
                        else
                            eTunable.Business.Nightclub.Price.Weapons:Reset()
                            eTunable.Business.Nightclub.Price.Coke:Reset()
                            eTunable.Business.Nightclub.Price.Meth:Reset()
                            eTunable.Business.Nightclub.Price.Weed:Reset()
                            eTunable.Business.Nightclub.Price.Documents:Reset()
                            eTunable.Business.Nightclub.Price.Cash:Reset()
                            eTunable.Business.Nightclub.Price.Cargo:Reset()
                            SilentLogger.LogInfo("[Maximize Price (Nightclub)] Price should've been reset ツ")
                            loggedNightclubPrice = false
                        end
                    end
                }
            },

            Misc = {
                Open = {
                    hash = J("SN_Nightclub_Open"),
                    name = "Open Computer",
                    type = eFeatureType.Button,
                    desc = "Opens the Nightclub's computer screen.",
                    func = function()
                        GTA.StartScript(eScript.Business.Nightclub)
                        SilentLogger.LogInfo("[Open Computer (Nightclub)] Computer screen should've been opened ツ")
                    end
                },

                Cooldown = {
                    hash = J("SN_Nighclub_Cooldown"),
                    name = "Kill Cooldowns",
                    type = eFeatureType.Toggle,
                    desc = "Skips almost all cooldowns.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            eTunable.Business.Nightclub.Cooldown.ClubManagement:Set(0)
                            eTunable.Business.Nightclub.Cooldown.Sell:Set(0)
                            eTunable.Business.Nightclub.Cooldown.SellDelivery:Set(0)

                            if not loggedNightclubCooldown then
                                SilentLogger.LogInfo("[Kill Cooldowns (Nightclub)] Cooldowns should've been killed ツ")
                                loggedNightclubCooldown = true
                            end
                        else
                            eTunable.Business.Nightclub.Cooldown.ClubManagement:Reset()
                            eTunable.Business.Nightclub.Cooldown.Sell:Reset()
                            eTunable.Business.Nightclub.Cooldown.SellDelivery:Reset()
                            SilentLogger.LogInfo("[Kill Cooldowns (Nightclub)] Cooldowns should've been reset ツ")
                            loggedNightclubCooldown = false
                        end
                    end
                },

                Setup = {
                    hash = J("SN_Nightclub_Setup"),
                    name = "Skip Setup",
                    type = eFeatureType.Button,
                    desc = "Skips the setup missions for your Nightclub. Change the session to apply.",
                    func = function()
                        ePackedBool.Business.Nightclub.Setup.Staff:Set(true)
                        ePackedBool.Business.Nightclub.Setup.Equipment:Set(true)
                        ePackedBool.Business.Nightclub.Setup.DJ:Set(true)
                        SilentLogger.LogInfo("[Skip Setup (Nightclub)] Setups should've been skipped. Don't forget to change the session ツ")
                    end
                }
            },

            Stats = {
                SellMade = {
                    hash = J("SN_Nightclub_SellMade"),
                    name = "Sell Made",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales made.",
                    defv = eStat.MPX_HUB_SALES_COMPLETED:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Made (Nightclub)] Sales made should've been changed. Don't forget to apply ツ")
                    end
                },

                Earnings = {
                    hash = J("SN_Nightclub_Earnings"),
                    name = "Earnings",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired earnings.",
                    defv = eStat.MPX_HUB_EARNINGS:Get(),
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Earnings (Nightclub)] Earnings should've been changed. Don't forget to apply ツ")
                    end
                },

                NoSell = {
                    hash = J("SN_Nightclub_NoSell"),
                    name = "Don't Apply Sell",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new sell missions or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Sell (Nightclub)] Selected sell: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                NoEarnings = {
                    hash = J("SN_Nightclub_NoEarnings"),
                    name = "Don't Apply Earnings",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new earnings or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Earnings (Nightclub)] Selected earnings: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                Apply = {
                    hash = J("SN_Nightclub_Apply"),
                    name = "Apply All Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes.",
                    func = function(bool1, bool2, buyMade, earnings)
                        if not bool1 then
                            eStat.MPX_HUB_SALES_COMPLETED:Set(buyMade)
                        end
                        if not bool2 then
                            eStat.MPX_HUB_EARNINGS:Set(earnings)
                        end
                        SilentLogger.LogInfo("[Apply All Changes (Nightclub)] Changes should've been applied ツ")
                    end
                }
            },

            Safe = {
                Fill = {
                    hash = J("SN_Nightclub_Fill"),
                    name = "Fill",
                    type = eFeatureType.Button,
                    desc = "Fills your Nightclub safe with money.",
                    func = function()
                        local top5     = eGlobal.Business.Nightclub.Safe.Income.Top5.global
                        local top100   = eGlobal.Business.Nightclub.Safe.Income.Top100.global
                        local maxValue = 300000

                        eTunable.Business.Nightclub.Safe.MaxCapacity:Set(maxValue)

                        for i = top5, top100 do
                            ScriptGlobal.SetInt(i, maxValue)
                        end

                        eStat.MPX_CLUB_PAY_TIME_LEFT:Set(-1)
                        SilentLogger.LogInfo("[Fill Safe (Nightclub)] Safe should've been filled ツ")
                    end
                },

                Collect = {
                    hash = J("SN_Nightclub_Collect"),
                    name = "Collect",
                    type = eFeatureType.Button,
                    desc = "Collects money from your safe. Use inside your Nightclub.",
                    func = function()
                        if eGlobal.Business.Nightclub.Safe.Value:Get() > 0 then
                            eLocal.Business.Nightclub.Safe.Type:Set(3)
                            eLocal.Business.Nightclub.Safe.Collect:Set(1)
                            SilentLogger.LogInfo("[Collect Safe (Nightclub)] Safe should've been collected ツ")
                        end
                    end
                },

                Unbrick = {
                    hash = J("SN_Nightclub_Unbrick"),
                    name = "Unbrick",
                    type = eFeatureType.Button,
                    desc = "Unbricks your safe if it shows a dollar sign with $0 inside. Use inside your Nightclub.",
                    func = function()
                        local top5   = eGlobal.Business.Nightclub.Safe.Income.Top5.global
                        local top100 = eGlobal.Business.Nightclub.Safe.Income.Top100.global

                        for i = top5, top100 do
                            ScriptGlobal.SetInt(i, 1)
                        end

                        eStat.MPX_CLUB_PAY_TIME_LEFT:Set(-1)
                        Script.Yield(3000)
                        eLocal.Business.Nightclub.Safe.Type:Set(3)
                        eLocal.Business.Nightclub.Safe.Collect:Set(1)
                        SilentLogger.LogInfo("[Unbrick Safe (Nightclub)] Safe should've been unbricked ツ")
                    end
                }
            },

            Popularity = {
                Lock = {
                    hash = J("SN_Nightclub_Lock"),
                    name = "Lock",
                    type = eFeatureType.Toggle,
                    desc = "Locks the popularity of your Nightclub on the current level.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            if NPOPULARITY == "TEMP" then
                                NPOPULARITY = eStat.MPX_CLUB_POPULARITY:Get()
                            end

                            eStat.MPX_CLUB_POPULARITY:Set(NPOPULARITY)

                            if not loggedNightclubLock then
                                SilentLogger.LogInfo(F("[Lock Popularity (Nightclub)] Popularity should've been locked at %d%%ツ", (NPOPULARITY ~= 0) and NPOPULARITY / 10 or 0))
                                loggedNightclubLock = true
                            end

                            Script.Yield(1000)
                        else
                            NPOPULARITY = "TEMP"
                            SilentLogger.LogInfo("[Lock Popularity (Nightclub)] Popularity should've been unlocked ツ")
                            loggedNightclubLock = false
                        end
                    end
                },

                Max = {
                    hash = J("SN_Nightclub_Max"),
                    name = "Max",
                    type = eFeatureType.Button,
                    desc = "Makes your Nightclub popular.",
                    func = function()
                        eStat.MPX_CLUB_POPULARITY:Set(1000)
                        SilentLogger.LogInfo("[Max Popularity (Nightclub)] Popularity should've been maximized ツ")
                    end
                },

                Min = {
                    hash = J("SN_Nightclub_Min"),
                    name = "Min",
                    type = eFeatureType.Button,
                    desc = "Makes your Nightclub unpopular.",
                    func = function()
                        eStat.MPX_CLUB_POPULARITY:Set(0)
                        SilentLogger.LogInfo("[Min Popularity (Nightclub)] Popularity should've been minimized ツ")
                    end
                }
            }
        },

        CrateWarehouse = {
            Sale = {
                Price = {
                    hash = J("SN_CrateWarehouse_Price"),
                    name = "Maximize Price",
                    type = eFeatureType.Toggle,
                    desc = "UNSAFE. Applies the maximum price for your crates.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            if not GTA.IsInSessionAlone() then
                                GTA.EmptySession()
                            end

                            local price = 6000000

                            eTunable.Business.CrateWarehouse.Price.Threshold1:Set(price)
                            eTunable.Business.CrateWarehouse.Price.Threshold2:Set(math.floor(price / 2))
                            eTunable.Business.CrateWarehouse.Price.Threshold3:Set(math.floor(price / 3))
                            eTunable.Business.CrateWarehouse.Price.Threshold4:Set(math.floor(price / 5))
                            eTunable.Business.CrateWarehouse.Price.Threshold5:Set(math.floor(price / 7))
                            eTunable.Business.CrateWarehouse.Price.Threshold6:Set(math.floor(price / 9))
                            eTunable.Business.CrateWarehouse.Price.Threshold7:Set(math.floor(price / 14))
                            eTunable.Business.CrateWarehouse.Price.Threshold8:Set(math.floor(price / 19))
                            eTunable.Business.CrateWarehouse.Price.Threshold9:Set(math.floor(price / 24))
                            eTunable.Business.CrateWarehouse.Price.Threshold10:Set(math.floor(price / 29))
                            eTunable.Business.CrateWarehouse.Price.Threshold11:Set(math.floor(price / 34))
                            eTunable.Business.CrateWarehouse.Price.Threshold12:Set(math.floor(price / 39))
                            eTunable.Business.CrateWarehouse.Price.Threshold13:Set(math.floor(price / 44))
                            eTunable.Business.CrateWarehouse.Price.Threshold14:Set(math.floor(price / 49))
                            eTunable.Business.CrateWarehouse.Price.Threshold15:Set(math.floor(price / 59))
                            eTunable.Business.CrateWarehouse.Price.Threshold16:Set(math.floor(price / 69))
                            eTunable.Business.CrateWarehouse.Price.Threshold17:Set(math.floor(price / 79))
                            eTunable.Business.CrateWarehouse.Price.Threshold18:Set(math.floor(price / 89))
                            eTunable.Business.CrateWarehouse.Price.Threshold19:Set(math.floor(price / 99))
                            eTunable.Business.CrateWarehouse.Price.Threshold20:Set(math.floor(price / 110))
                            eTunable.Business.CrateWarehouse.Price.Threshold21:Set(math.floor(price / 111))

                            if not loggedSpecialPrice then
                                SilentLogger.LogInfo("[Maximize Price (Crate Warehouse)] Price should've been maximized ツ")
                                loggedSpecialPrice = true
                            end
                        else
                            for i = 1, 21 do
                                eTunable.Business.CrateWarehouse.Price[F("Threshold%d", i)]:Reset()
                            end
                            SilentLogger.LogInfo("[Maximize Price (Crate Warehouse)] Price should've been reset ツ")
                            loggedSpecialPrice = false
                        end
                    end
                },

                NoXp = {
                    hash = J("SN_CrateWarehouse_NoXp"),
                    name = "No XP Gain",
                    type = eFeatureType.Toggle,
                    desc = "Disables the xp gain for sell missions.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[No XP Gain (Crate Warehouse)] XP gain should've been %s ツ", (ftr:IsToggled()) and "disabled" or "enabled"))
                    end
                },

                NoCrateback = {
                    hash = J("SN_CrateWarehouse_NoCrateback"),
                    name = "No CrateBack",
                    type = eFeatureType.Toggle,
                    desc = "Disables auto refill of the crates after «Instant Sell».",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[No CrateBack (Crate Warehouse)] Crate refill should've been %s ツ", (ftr:IsToggled()) and "disabled" or "enabled"))
                    end
                },

                Sell = {
                    hash = J("SN_CrateWarehouse_Sell"),
                    name = "Instant Sell",
                    type = eFeatureType.Button,
                    desc = "Finishes the sell mission instantly. Use after you can see the minimap.",
                    func = function(bool1, bool2)
                        if not bool2 then
                            if GTA.IsScriptRunning(eScript.Business.CrateWarehouse.Sell) then
                                ePackedBool.Business.CrateWarehouse.Cargo:Set(true)
                            end
                        end
                        eGlobal.World.Multiplier.Xp:Set((bool1) and 0.0 or 1.0)
                        eLocal.Business.CrateWarehouse.Sell.Type:Set(7)
                        eLocal.Business.CrateWarehouse.Sell.Finish:Set(99999)
                        Script.Yield(2000)
                        eLocal.Business.CrateWarehouse.Sell.Finish:Set(99999)
                        SilentLogger.LogInfo("[Instant Sell (Crate Warehouse)] Sell mission should've been finished ツ")
                    end
                }
            },

            Misc = {
                Supply = {
                    hash = J("SN_CrateWarehouse_Supply"),
                    name = "Get Crates",
                    type = eFeatureType.Button,
                    desc = "Gets crates for your Crate Warehouse.",
                    func = function()
                        ePackedBool.Business.CrateWarehouse.Cargo:Set(true)
                        SilentLogger.LogInfo("[Get Crates (Crate Warehouse)] Crates should've been received ツ")
                    end
                },

                Select = {
                    hash = J("SN_CrateWarehouse_Select"),
                    name = "Crates Amount",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired crates amount to buy.",
                    defv = 0,
                    lims = { 0, 111 },
                    step = 1,
                    func = function()
                        SilentLogger.LogInfo("[Crates Amount (Crate Warehouse)] Crates amount should've been changed ツ")
                    end
                },

                Max = {
                    hash = J("SN_CrateWarehouse_Max"),
                    name = "Max",
                    type = eFeatureType.Button,
                    desc = "Maximizes the crates amount, but not buying them.",
                    func = function()
                        SilentLogger.LogInfo("[Max (Crate Warehouse)] Crates amount should've been maximized. Don't forget to apply ツ")
                    end
                },

                Buy = {
                    hash = J("SN_CrateWarehouse_Buy"),
                    name = "Instant Buy",
                    type = eFeatureType.Button,
                    desc = "Finishes the buy mission instantly. Use after you can see the minimap.",
                    func = function(amount)
                        eLocal.Business.CrateWarehouse.Buy.Amount:Set(amount)
                        eLocal.Business.CrateWarehouse.Buy.Finish1:Set(1)
                        eLocal.Business.CrateWarehouse.Buy.Finish2:Set(6)
                        eLocal.Business.CrateWarehouse.Buy.Finish3:Set(4)
                        SilentLogger.LogInfo("[Instant Buy (Crate Warehouse)] Buy mission should've been finished ツ")
                    end
                },

                Supplier = {
                    hash = J("SN_CrateWarehouse_Supplier"),
                    name = "Turkish Supplier",
                    type = eFeatureType.Toggle,
                    desc = "Fills your Crate Warehouse stock repeatedly.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            ePackedBool.Business.CrateWarehouse.Cargo:Set(true)

                            if not loggedSpecialSupplier then
                                SilentLogger.LogInfo("[Turkish Supplier (Crate Warehouse)] Supplier should've been enabled ツ")
                                loggedCrateSupplier = true
                            end

                            Script.Yield(1000)
                        else
                            SilentLogger.LogInfo("[Turkish Supplier (Crate Warehouse)] Supplier should've been disabled ツ")
                            loggedSpecialSupplier = false
                        end
                    end
                },

                Cooldown = {
                    hash = J("SN_CrateWarehouse_Cooldown"),
                    name = "Kill Cooldowns",
                    type = eFeatureType.Toggle,
                    desc = "Skips almost all cooldowns.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            eTunable.Business.CrateWarehouse.Cooldown.Buy:Set(0)
                            eTunable.Business.CrateWarehouse.Cooldown.Sell:Set(0)

                            if not loggedSpecialCooldown then
                                SilentLogger.LogInfo("[Kill Cooldowns (Crate Warehouse)] Cooldowns should've been killed ツ")
                                loggedSpecialCooldown = true
                            end
                        else
                            eTunable.Business.CrateWarehouse.Cooldown.Buy:Reset()
                            eTunable.Business.CrateWarehouse.Cooldown.Sell:Reset()
                            SilentLogger.LogInfo("[Kill Cooldowns (Crate Warehouse)] Cooldowns should've been reset ツ")
                            loggedSpecialCooldown = false
                        end
                    end
                }
            },

            Stats = {
                BuyMade = {
                    hash = J("SN_CrateWarehouse_BuyMade"),
                    name = "Buy Made",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired buy made.",
                    defv = eStat.MPX_LIFETIME_BUY_COMPLETE:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Buy Made (Crate Warehouse)] Buy made should've been changed. Don't forget to apply ツ")
                    end
                },

                BuyUndertaken = {
                    hash = J("SN_CrateWarehouse_BuyUndertaken"),
                    name = "Buy Undertaken",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired buy undertaken.",
                    defv = eStat.MPX_LIFETIME_BUY_UNDERTAKEN:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Buy Undertaken (Crate Warehouse)] Buy undertaken should've been changed. Don't forget to apply ツ")
                    end
                },

                SellMade = {
                    hash = J("SN_CrateWarehouse_SellMade"),
                    name = "Sell Made",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales made.",
                    defv = eStat.MPX_LIFETIME_SELL_COMPLETE:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Made (Crate Warehouse)] Sales made should've been changed. Don't forget to apply ツ")
                    end
                },

                SellUndertaken = {
                    hash = J("SN_CrateWarehouse_SellUndertaken"),
                    name = "Sell Undertaken",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired sales undertaken.",
                    defv = eStat.MPX_LIFETIME_SELL_UNDERTAKEN:Get(),
                    lims = { 0, INT32_MAX },
                    step = 10,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Sell Undertaken (Crate Warehouse)] Sales undertaken should've been changed. Don't forget to apply ツ")
                    end
                },

                Earnings = {
                    hash = J("SN_CrateWarehouse_Earnings"),
                    name = "Earnings",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired earnings.",
                    defv = eStat.MPX_LIFETIME_CONTRA_EARNINGS:Get(),
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Earnings (Crate Warehouse)] Earnings should've been changed. Don't forget to apply ツ")
                    end
                },

                NoBuy = {
                    hash = J("SN_CrateWarehouse_NoBuy"),
                    name = "Don't Apply Buy",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new buy missions or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Buy (Crate Warehouse)] Selected buy: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                NoSell = {
                    hash = J("SN_CrateWarehouse_NoSell"),
                    name = "Don't Apply Sell",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new sell missions or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Sell (Crate Warehouse)] Selected sell: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                NoEarnings = {
                    hash = J("SN_CrateWarehouse_NoEarnings"),
                    name = "Don't Apply Earnings",
                    type = eFeatureType.Toggle,
                    desc = "Decides whether you want to apply new earnings or not.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Don't Apply Earnings (Crate Warehouse)] Selected earnings: %s ツ", (ftr:IsToggled()) and "Don't Apply" or "Apply"))
                    end
                },

                Apply = {
                    hash = J("SN_CrateWarehouse_Apply"),
                    name = "Apply All Changes",
                    type = eFeatureType.Button,
                    desc = "Applies all changes.",
                    func = function(bool1, bool2, bool3, buyMade, buyUndertaken, sellMade, sellUndertaken, earnings)
                        if not bool1 then
                            eStat.MPX_LIFETIME_BUY_COMPLETE:Set(buyMade)
                            eStat.MPX_LIFETIME_BUY_UNDERTAKEN:Set(buyUndertaken)
                        end
                        if not bool2 then
                            eStat.MPX_LIFETIME_SELL_COMPLETE:Set(sellMade)
                            eStat.MPX_LIFETIME_SELL_UNDERTAKEN:Set(sellUndertaken)
                        end
                        if not bool3 then
                            eStat.MPX_LIFETIME_CONTRA_EARNINGS:Set(earnings)
                        end
                        SilentLogger.LogInfo("[Apply All Changes (Crate Warehouse)] Changes should've been applied ツ")
                    end
                }
            }
        },

        Misc = {
            Supplies = {
                Business = {
                    hash = J("SN_Misc_SuppliesBusiness"),
                    name = "Business",
                    type = eFeatureType.Combo,
                    desc = "Select the desired business. If you don't see all the businesses, change the session.",
                    list = eTable.Business.Supplies,
                    func = function(ftr)
                        local list  = eTable.Business.Supplies
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Business (Misc)] Selected business: %s ツ", list:GetName(index)))
                    end
                },

                Resupply = {
                    hash = J("SN_Misc_SuppliesResupply"),
                    name = "Resupply",
                    type = eFeatureType.Button,
                    desc = "Resupplies the selected business.",
                    func = function(business)
                        if business == -1 then
                            SilentLogger.LogError("[Resupply (Misc)] You must get a business first ツ")
                            return
                        end

                        local businesses = {
                            [0] = eGlobal.Business.Supplies.Slot0,
                            [1] = eGlobal.Business.Supplies.Slot1,
                            [2] = eGlobal.Business.Supplies.Slot2,
                            [3] = eGlobal.Business.Supplies.Slot3,
                            [4] = eGlobal.Business.Supplies.Slot4,
                            [5] = eGlobal.Business.Supplies.Bunker,
                            [6] = eGlobal.Business.Supplies.Acid
                        }

                        if business == 7 then
                            for _, index in ipairs(eTable.Business.Supplies:GetIndexes()) do
                                if index ~= 7 then
                                    businesses[index]:Set(1)
                                end
                            end

                            SilentLogger.LogInfo("[Resupply (Misc)] All businesses should've been resupplied ツ")
                            return
                        end

                        businesses[business]:Set(1)
                        SilentLogger.LogInfo("[Resupply (Misc)] Business should've been resupplied ツ")
                    end
                }
            }
        }
    },

    Money = {
        Casino = {
            LuckyWheel = {
                Select = {
                    hash = J("SN_Casino_LuckyWheelSelect"),
                    name = "Prize",
                    type = eFeatureType.Combo,
                    desc = "Select the desired prize.",
                    list = eTable.World.Casino.Prizes,
                    func = function(ftr)
                        local list  = eTable.World.Casino.Prizes
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Prize (Casino)] Selected prize: %s ツ", list:GetName(index)))
                    end
                },

                Give = {
                    hash = J("SN_Casino_LuckyWheelGive"),
                    name = "Give Prize",
                    type = eFeatureType.Button,
                    desc = "Gives the selected prize instantly. Use once per day.",
                    func = function(prize)
                        eLocal.World.Casino.LuckyWheel.WinState:Set(prize)
                        eLocal.World.Casino.LuckyWheel.PrizeState:Set(11)
                        SilentLogger.LogInfo("[Prize (Casino)] Prize should've been given ツ")
                    end
                }
            },

            Slots = {
                Win = {
                    hash = J("SN_Casino_SlotsWin"),
                    name = "Rig Slots",
                    type = eFeatureType.Button,
                    desc = "UNSAFE. Forces the slots to give you the jackpot.",
                    func = function()
                        local randomResultTable = eLocal.World.Casino.Slots.RandomResultTable.vLocal

                        for i = 3, 196 do
                            if i ~= 67 and i ~= 132 then
                                ScriptLocal.SetInt(eScript.World.Casino.Slots.hash, randomResultTable + i, 6)
                            end
                        end

                        SilentLogger.LogInfo("[Rig Slots (Casino)] Slots should've been rigged ツ")
                    end
                },

                Lose = {
                    hash = J("SN_Casino_SlotsLoose"),
                    name = "Lose Slots",
                    type = eFeatureType.Button,
                    desc = "Forces the slots to always lose.",
                    func = function()
                        local randomResultTable = eLocal.World.Casino.Slots.RandomResultTable.vLocal

                        for i = 3, 196 do
                            if i ~= 67 and i ~= 132 then
                                ScriptLocal.SetInt(eScript.World.Casino.Slots.hash, randomResultTable + i, 0)
                            end
                        end

                        SilentLogger.LogInfo("[Lose Slots (Casino)] Slots should've been rigged ツ")
                    end
                }
            },

            Roulette = {
                Land13 = {
                    hash = J("SN_Casino_RouletteLand13"),
                    name = "Land On Black 13",
                    type = eFeatureType.Button,
                    desc = "Forces the ball to land on Black 13. Use after there is no time for betting.",
                    func = function()
                        GTA.ForceScriptHost(eScript.World.Casino.Roulette)
                        local masterTable   = eLocal.World.Casino.Roulette.MasterTable.vLocal
                        local outcomesTable = eLocal.World.Casino.Roulette.OutcomesTable.vLocal
                        local ballTable     = eLocal.World.Casino.Roulette.BallTable.vLocal

                        for i = 0, 5 do
                            ScriptLocal.SetInt(eScript.World.Casino.Roulette.hash, masterTable + outcomesTable + ballTable + i, 13)
                        end

                        SilentLogger.LogInfo("[Land On Black 13 (Casino)] Ball should've landed on Black 13 ツ")
                    end
                },

                Land16 = {
                    hash = J("SN_Casino_RouletteLand16"),
                    name = "Land On Red 16",
                    type = eFeatureType.Button,
                    desc = "Forces the ball to land on Red 16. Use after there is no time for betting.",
                    func = function()
                        GTA.ForceScriptHost(eScript.World.Casino.Roulette)
                        local masterTable   = eLocal.World.Casino.Roulette.MasterTable.vLocal
                        local outcomesTable = eLocal.World.Casino.Roulette.OutcomesTable.vLocal
                        local ballTable     = eLocal.World.Casino.Roulette.BallTable.vLocal

                        for i = 0, 5 do
                            ScriptLocal.SetInt(eScript.World.Casino.Roulette.hash, masterTable + outcomesTable + ballTable + i, 16)
                        end

                        SilentLogger.LogInfo("[Land On Red 16 (Casino)] Ball should've landed on Red 16 ツ")
                    end
                }
            },

            Blackjack = {
                Card = {
                    hash = J("SN_Casino_BlackjackCard"),
                    name = "Dealer's Face Down Card",
                    type = eFeatureType.InputText,
                    desc = "Shows the dealer's face down card."
                },

                Reveal = {
                    hash = J("SN_Casino_BlackjackReveal"),
                    name = "Reveal Card",
                    type = eFeatureType.Button,
                    desc = "Reveals the dealer's face down card. Works better in solo session.",
                    func = function()
                        SilentLogger.LogInfo("[Reveal Card (Casino)] Card should've been revealed ツ")
                    end
                },

                Trick = {
                    hash = J("SN_Casino_BlackjackTrick"),
                    name = "Trick The Dealer",
                    type = eFeatureType.Button,
                    desc = "Forces the dealer's hand to lose. Also, reveals the dealer's cards. Works better in solo session.",
                    func = function()
                        GTA.ForceScriptHost(eScript.World.Casino.Blackjack)
                        if eLocal.World.Casino.Blackjack.CurrentTable:Get() ~= -1 then
                            eLocal.World.Casino.Blackjack.Dealer.FirstCard:Set(11)
                            eLocal.World.Casino.Blackjack.Dealer.SecondCard:Set(12)
                            eLocal.World.Casino.Blackjack.Dealer.ThirdCard:Set(13)
                            eLocal.World.Casino.Blackjack.VisibleCards:Set(3)
                        end
                        SilentLogger.LogInfo("[Trick The Dealer (Casino)] Dealer's hand should've been tricked ツ")
                    end
                }
            },

            Poker = {
                MyCards = {
                    hash = J("SN_Casino_PokerMyCards"),
                    name = "Your Cards",
                    type = eFeatureType.InputText,
                    desc = "Shows your cards."
                },

                Cards = {
                    hash = J("SN_Casino_PokerCards"),
                    name = "Dealer's Cards",
                    type = eFeatureType.InputText,
                    desc = "Shows the dealer's cards."
                },

                Reveal = {
                    hash = J("SN_Casino_PokerReveal"),
                    name = "Reveal Cards",
                    type = eFeatureType.Button,
                    desc = "Reveals your and the dealer's cards. Works better in solo session.",
                    func = function()
                        SilentLogger.LogInfo("[Reveal Cards (Casino)] Cards should've been revealed ツ")
                    end
                },

                Give = {
                    hash = J("SN_Casino_PokerGive"),
                    name = "Give Straight Flush",
                    type = eFeatureType.Button,
                    desc = "Forces your hand to win. Also, reveals your and the dealer's cards. Use during the animation of your character getting at a table. Works better in solo session.",
                    func = function()
                        GTA.ForceScriptHost(eScript.World.Casino.Poker)
                        Helper.SetPokerCards(0, 50, 51, 52)
                        SilentLogger.LogInfo("[Give Straight Flush (Casino)] Your hand should've been given a straight flush ツ")
                    end
                },

                Trick = {
                    hash = J("SN_Casino_PokerTrick"),
                    name = "Trick The Dealer",
                    type = eFeatureType.Button,
                    desc = "Forces the dealer's hand to lose. Also, reveals your and the dealer's cards. Use during the animation of your character getting at a table. Works better in solo session.",
                    func = function()
                        GTA.ForceScriptHost(eScript.World.Casino.Poker)
                        if eLocal.World.Casino.Poker.CurrentTable:Get() ~= -1 then
                            local id = Helper.GetPokerPlayersCount() + 1
                            Helper.SetPokerCards(id, 2, 17, 32)
                        end
                        SilentLogger.LogInfo("[Trick The Dealer (Casino)] Dealer's hand should've been tricked ツ")
                    end
                }
            },

            Misc = {
                Bypass = {
                    hash = J("SN_Casino_Bypass"),
                    name = "Bypass Casino Limits",
                    type = eFeatureType.Toggle,
                    desc = "Bypasses the casino limits. Might be unsafe if used to earn more chips.",
                    func = function(ftr)
                        if ftr:IsToggled() then
                            eStat.MPPLY_CASINO_CHIPS_WON_GD:Set(0)
                            eStat.MPPLY_CASINO_CHIPS_WONTIM:Set(0)
                            eStat.MPPLY_CASINO_GMBLNG_GD:Set(0)
                            eStat.MPPLY_CASINO_BAN_TIME:Set(0)
                            eStat.MPPLY_CASINO_CHIPS_PURTIM:Set(0)
                            eStat.MPPLY_CASINO_CHIPS_PUR_GD:Set(0)

                            if not loggedCasinoLimits then
                                SilentLogger.LogInfo("[Bypass Casino Limits (Casino)] Casino limits should've been bypassed ツ")
                                loggedCasinoLimits = true
                            end
                        else
                            eTunable.World.Casino.Chips.Limit.Acquire:Reset()
                            eTunable.World.Casino.Chips.Limit.AcquirePenthouse:Reset()
                            eTunable.World.Casino.Chips.Limit.Sell:Reset()
                            SilentLogger.LogInfo("[Bypass Casino Limits (Casino)] Casino limits should've been reset ツ")
                            loggedCasinoLimits = false
                        end
                    end
                },

                Limit = {
                    Select = {
                        hash = J("SN_Casino_Select"),
                        name = "Chips Limit",
                        type = eFeatureType.InputInt,
                        desc = "Select the desired chips limit.",
                        defv = 0,
                        lims = { 0, INT32_MAX },
                        step = 1000000,
                        func = function(ftr)
                            SilentLogger.LogInfo("[Chips Limit (Casino)] Chips limit should've been changed. Don't forget to apply ツ")
                        end
                    },

                    Acquire = {
                        hash = J("SN_Casino_Acquire"),
                        name = "Apply Acquire Limit",
                        type = eFeatureType.Button,
                        desc = "Applies the selected acquire chips limit.",
                        func = function(limit)
                            eTunable.World.Casino.Chips.Limit.Acquire:Set(limit)
                            eTunable.World.Casino.Chips.Limit.AcquirePenthouse:Set(limit)
                            SilentLogger.LogInfo("[Apply Acquire Limit (Casino)] Acquire chips limit should've been applied ツ")
                        end
                    },

                    Trade = {
                        hash = J("SN_Casino_Sell"),
                        name = "Apply Trade In Limit",
                        type = eFeatureType.Button,
                        desc = "MIGHT BE UNSAFE. Applies the selected trade in chips limit.",
                        func = function(limit)
                            eTunable.World.Casino.Chips.Limit.Sell:Set(limit)
                            SilentLogger.LogInfo("[Apply Trade In Limit (Casino)] Trade in chips limit should've been applied ツ")
                        end
                    }
                }
            }
        },

        EasyMoney = {
            Instant = {
                Give30m = {
                    hash = J("SN_EasyMoney_30m"),
                    name = "Give 30mil",
                    type = eFeatureType.Button,
                    desc = "MIGHT BE UNSAFE. Gives 30mil dollars in a few seconds. Has a cooldown of about 1 hour.",
                    func = function()
                        GTA.TriggerTransaction(0xA174F633)
                        Script.Yield(3000)
                        GTA.TriggerTransaction(0xED97AFC1)
                        Script.Yield(3000)
                        GTA.TriggerTransaction(0x176D9D54)
                        Script.Yield(3000)
                        GTA.TriggerTransaction(0x4B6A869C)
                        Script.Yield(3000)
                        GTA.TriggerTransaction(0x921FCF3C)
                        Script.Yield(3000)
                        GTA.TriggerTransaction(0x314FB8B0)
                        SilentLogger.LogInfo("[Give 30mil (Easy Money)] 30mil dollars should've been given ツ")
                    end
                }
            },

            Freeroam = {
                _5k = {
                    hash = J("SN_EasyMoney_5k"),
                    name = "5k Loop",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Toggles the 5k chips loop.",
                    func = function(ftr, delay)
                        if ftr:IsToggled() then
                            eGlobal.World.Casino.Chips.Bonus:Set(1)

                            if not logged5kLoop then
                                SilentLogger.LogInfo("[5k Loop (Easy Money)] 5k chips loop should've been enabled ツ")
                                logged5kLoop = true
                            end

                            Script.Yield(math.floor(delay * 1000))
                        else
                            SilentLogger.LogInfo("[5k Loop (Easy Money)] 5k chips loop should've been disabled ツ")
                            logged5kLoop = false
                        end
                    end
                },

                _50k = {
                    hash = J("SN_EasyMoney_50k"),
                    name = "50k Loop",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Toggles the 50k dollars loop.",
                    func = function(ftr, delay)
                        if ftr:IsToggled() then
                            GTA.TriggerTransaction(0x610F9AB4)

                            if not logged50kLoop then
                                SilentLogger.LogInfo("[50k Loop (Easy Money)] 50k dollars loop should've been enabled ツ")
                                logged50kLoop = true
                            end

                            Script.Yield(math.floor(delay * 1000))
                        else
                            SilentLogger.LogInfo("[50k Loop (Easy Money)] 50k dollars loop should've been disabled ツ")
                            logged50kLoop = false
                        end
                    end
                },

                _100k = {
                    hash = J("SN_EasyMoney_100k"),
                    name = "100k Loop",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Toggles the 100k dollars loop.",
                    func = function(ftr, delay)
                        if ftr:IsToggled() then
                            GTA.TriggerTransaction(J("SERVICE_EARN_AMBIENT_JOB_AMMUNATION_DELIVERY"))

                            if not logged100kLoop then
                                SilentLogger.LogInfo("[100k Loop (Easy Money)] 100k dollars loop should've been enabled ツ")
                                logged100kLoop = true
                            end

                            Script.Yield(math.floor(delay * 1000))
                        else
                            SilentLogger.LogInfo("[100k Loop (Easy Money)] 100k dollars loop should've been disabled ツ")
                            logged100kLoop = false
                        end
                    end
                },

                _180k = {
                    hash = J("SN_EasyMoney_180k"),
                    name = "180k Loop",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Toggles the 180k dollars loop. Has a cooldown after gaining a certain amount of money.",
                    func = function(ftr, delay)
                        if ftr:IsToggled() then
                            GTA.TriggerTransaction(0x615762F1)

                            if not logged180kLoop then
                                SilentLogger.LogInfo("[180k Loop (Easy Money)] 180k dollars loop should've been enabled ツ")
                                logged180kLoop = true
                            end

                            Script.Yield(math.floor(delay * 1000))
                        else
                            SilentLogger.LogInfo("[180k Loop (Easy Money)] 180k dollars loop should've been disabled ツ")
                            logged180kLoop = false
                        end
                    end
                }
            },

            Property = {
                _300k = {
                    hash = J("SN_EasyMoney_300k"),
                    name = "300k Loop",
                    type = eFeatureType.Toggle,
                    desc = "MIGHT BE UNSAFE. Toggles the 300k dollars loop. Use inside your Nightclub. Has a cooldown after gaining a certain amount of money.",
                    func = function(ftr, delay)
                        if ftr:IsToggled() then
                            local top5      = eGlobal.Business.Nightclub.Safe.Income.Top5.global
                            local top100    = eGlobal.Business.Nightclub.Safe.Income.Top100.global
                            local safeValue = eGlobal.Business.Nightclub.Safe.Value:Get()
                            local maxValue  = 300000

                            eTunable.Business.Nightclub.Safe.MaxCapacity:Set(maxValue)

                            for i = top5, top100 do
                                ScriptGlobal.SetInt(i, maxValue)
                            end

                            if safeValue <= maxValue and safeValue ~= 0 then
                                eLocal.Business.Nightclub.Safe.Type:Set(3)
                                eLocal.Business.Nightclub.Safe.Collect:Set(1)
                            elseif safeValue == 0 then
                                eStat.MPX_CLUB_PAY_TIME_LEFT:Set(-1)
                            end

                            if not logged300kLoop then
                                SilentLogger.LogInfo("[300k Loop (Easy Money)] 300k dollars loop should've been enabled ツ")
                                logged300kLoop = true
                            end

                            Script.Yield(math.floor(delay * 1000))
                        else
                            SilentLogger.LogInfo("[300k Loop (Easy Money)] 300k dollars loop should've been disabled ツ")
                            logged300kLoop = false
                        end
                    end
                }
            }
        },

        Misc = {
            Edit = {
                Select = {
                    hash = J("SN_Misc_EditSelect"),
                    name = "Money Amount",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired money amount.",
                    defv = 0,
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Money Amount (Misc)] Money amount should've been changed. Don't forget to apply ツ")
                    end
                },

                Deposit = {
                    hash = J("SN_Misc_EditDeposit"),
                    name = "Deposit",
                    type = eFeatureType.Button,
                    desc = "Deposits the selected money amount to your bank.",
                    func = function(amount)
                        if amount == 0 then
                            SilentLogger.LogError("[Deposit (Misc)] You must select a money amount first ツ")
                            return
                        end

                        local charSlot    = eStat.MPPLY_LAST_MP_CHAR:Get()
                        local walletMoney = eNative.MONEY.NETWORK_GET_VC_WALLET_BALANCE(charSlot)
                        local amount      = (amount > walletMoney) and walletMoney or amount
                        eNative.NETSHOPPING.NET_GAMESERVER_TRANSFER_WALLET_TO_BANK(charSlot, amount)
                        SilentLogger.LogInfo("[Deposit (Misc)] Money amount should've been deposited ツ")
                    end
                },

                Withdraw = {
                    hash = J("SN_Misc_EditWithdraw"),
                    name = "Withdraw",
                    type = eFeatureType.Button,
                    desc = "Withdraws the selected money amount from your bank.",
                    func = function(amount)
                        if amount == 0 then
                            SilentLogger.LogError("[Withdraw (Misc)] You must select a money amount first ツ")
                            return
                        end

                        local charSlot  = eStat.MPPLY_LAST_MP_CHAR:Get()
                        local bankMoney = eNative.MONEY.NETWORK_GET_VC_BANK_BALANCE()
                        local amount    = (amount > bankMoney) and bankMoney or amount
                        eNative.NETSHOPPING.NET_GAMESERVER_TRANSFER_BANK_TO_WALLET(charSlot, amount)
                        SilentLogger.LogInfo("[Withdraw (Misc)] Money amount should've been withdrawn ツ")
                    end
                },

                Remove = {
                    hash = J("SN_Misc_Remove"),
                    name = "Remove",
                    type = eFeatureType.Button,
                    desc = "Removes the selected money amount from your character.",
                    func = function(amount)
                        if amount == 0 then
                            SilentLogger.LogError("[Remove (Misc)] You must select a money amount first ツ")
                            return
                        end

                        local charSlot    = eStat.MPPLY_LAST_MP_CHAR:Get()
                        local bankMoney   = eNative.MONEY.NETWORK_GET_VC_BANK_BALANCE()
                        local walletMoney = eNative.MONEY.NETWORK_GET_VC_WALLET_BALANCE(charSlot)
                        local amount      = (amount > bankMoney + walletMoney) and bankMoney + walletMoney or amount
                        eGlobal.Player.Cash.Remove:Set(amount)
                        SilentLogger.LogInfo("[Remove (Misc)] Money amount should've been removed ツ")
                    end
                },

                DepositAll = {
                    hash = J("SN_Misc_EditDepositAll"),
                    name = "Deposit All",
                    type = eFeatureType.Button,
                    desc = "Deposits all money to your bank.",
                    func = function()
                        local charSlot    = eStat.MPPLY_LAST_MP_CHAR:Get()
                        local walletMoney = eNative.MONEY.NETWORK_GET_VC_WALLET_BALANCE(charSlot)
                        eNative.NETSHOPPING.NET_GAMESERVER_TRANSFER_WALLET_TO_BANK(charSlot, walletMoney)
                        SilentLogger.LogInfo("[Deposit All (Misc)] Money should've been deposited ツ")
                    end
                },

                WithdrawAll = {
                    hash = J("SN_Misc_EditWithdrawAll"),
                    name = "Withdraw All",
                    type = eFeatureType.Button,
                    desc = "Withdraws all money from your bank.",
                    func = function()
                        local charSlot  = eStat.MPPLY_LAST_MP_CHAR:Get()
                        local bankMoney = eNative.MONEY.NETWORK_GET_VC_BANK_BALANCE()
                        eNative.NETSHOPPING.NET_GAMESERVER_TRANSFER_BANK_TO_WALLET(charSlot, bankMoney)
                        SilentLogger.LogInfo("[Withdraw All (Misc)] Money should've been withdrawn ツ")
                    end
                }
            },

            Story = {
                Select = {
                    hash = J("SN_Misc_StorySelect"),
                    name = "Money Amount",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired money amount.",
                    defv = eStat.SP0_TOTAL_CASH:Get(),
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Money Amount (Misc)] Money amount should've been changed. Don't forget to apply ツ")
                    end
                },

                Character = {
                    hash = J("SN_Misc_StoryCharacter"),
                    name = "Character",
                    type = eFeatureType.Combo,
                    desc = "Select the desired story character.",
                    list = eTable.Story.Characters,
                    func = function(ftr)
                        local list  = eTable.Story.Characters
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Character (Misc)] Selected character: %s ツ", list:GetName(index)))
                    end
                },

                Apply = {
                    hash = J("SN_Misc_StoryApply"),
                    name = "Apply Money Amount",
                    type = eFeatureType.Button,
                    desc = "Applies the selected money amount to the selected story character.",
                    func = function(charIndex, amount)
                        eStat[F("SP%d_TOTAL_CASH", charIndex)]:Set(amount)
                        SilentLogger.LogInfo(F("[Apply Money Amount (Misc)] Money amount should've been applied ツ"))
                    end
                }
            },

            Stats = {
                Select = {
                    hash = J("SN_Misc_StatsSelect"),
                    name = "Money Amount",
                    type = eFeatureType.InputInt,
                    desc = "Select the desired money amount.",
                    defv = 0,
                    lims = { 0, INT32_MAX },
                    step = 1000000,
                    func = function(ftr)
                        SilentLogger.LogInfo("[Money Amount (Misc)] Money amount should've been changed. Don't forget to apply ツ")
                    end
                },

                Earned = {
                    hash = J("SN_Misc_StatsEarned"),
                    name = "Earned",
                    type = eFeatureType.Combo,
                    desc = "Select the desired «Earned» stat.",
                    list = eTable.Cash.Stats.Earneds,
                    func = function(ftr)
                        local list  = eTable.Cash.Stats.Earneds
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Earned (Misc)] Selected stat: %s ツ", list:GetName(index)))
                    end
                },

                Spent = {
                    hash = J("SN_Misc_StatsSpent"),
                    name = "Spent",
                    type = eFeatureType.Combo,
                    desc = "Select the desired «Spent» stat.",
                    list = eTable.Cash.Stats.Spents,
                    func = function(ftr)
                        local list  = eTable.Cash.Stats.Spents
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Spent (Misc)] Selected stat: %s ツ", list:GetName(index)))
                    end
                },

                Apply = {
                    hash = J("SN_Misc_StatsApply"),
                    name = "Apply Money Amount",
                    type = eFeatureType.Button,
                    desc = "Applies the selected money amount to the selected stat.",
                    func = function(earnedStat, spentStat, amount)
                        if earnedStat ~= 0 then
                            earnedStat:Set(amount)
                            SilentLogger.LogInfo("[Apply Money Amount (Misc)] Earned stat should've been changed ツ")
                            return
                        end
                        if spentStat ~= 0 then
                            spentStat:Set(amount)
                            SilentLogger.LogInfo("[Apply Money Amount (Misc)] Spent stat should've been changed ツ")
                            return
                        end
                        SilentLogger.LogError("[Apply Money Amount (Misc)] You must select a stat first ツ")
                    end
                }
            }
        }
    },

    Dev = {
        Editor = {
            Globals = {
                Type = {
                    hash = J("SN_Editor_GlobalsType"),
                    name = "Type",
                    type = eFeatureType.Combo,
                    desc = "Select the desired global type.",
                    list = eTable.Editor.Globals.Types,
                    func = function(ftr)
                        local list  = eTable.Editor.Globals.Types
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Type (Globals)] Selected global type: %s ツ", list:GetName(index)))
                    end
                },

                Global = {
                    hash = J("SN_Editor_GlobalsGlobal"),
                    name = "262145 + 9415",
                    type = eFeatureType.InputText,
                    desc = "Input your global here."
                },

                Value = {
                    hash = J("SN_Editor_GlobalsValue"),
                    name = "100",
                    type = eFeatureType.InputText,
                    desc = "Input your value here."
                },

                Read = {
                    hash = J("SN_Editor_GlobalsRead"),
                    name = "Read",
                    type = eFeatureType.Button,
                    desc = "Reads the entered global value.",
                    func = function()
                        SilentLogger.LogInfo("[Read (Dev Tool)] Value should've been read from global ツ")
                    end
                },

                Write = {
                    hash = J("SN_Editor_GlobalsWrite"),
                    name = "Write",
                    type = eFeatureType.Button,
                    desc = "Writes the selected value to the entered global.",
                    func = function(type, global, value)
                        local SetValue = {
                            ["int"]   = ScriptGlobal.SetInt,
                            ["float"] = ScriptGlobal.SetFloat,
                            ["bool"]  = ScriptGlobal.SetBool
                        }

                        SetValue[type](global, value)
                        SilentLogger.LogInfo("[Write (Dev Tool)] Value should've been written to global ツ")
                    end
                },

                Revert = {
                    hash = J("SN_Editor_GlobalsRevert"),
                    name = "Revert",
                    type = eFeatureType.Button,
                    desc = "Reverts the previous value you've written to the entered global.",
                    func = function(type, global)
                        local SetValue = {
                            ["int"]   = ScriptGlobal.SetInt,
                            ["float"] = ScriptGlobal.SetFloat,
                            ["bool"]  = ScriptGlobal.SetBool
                        }

                        if TEMP_GLOBAL ~= "TEMP" then
                            SetValue[type](global, TEMP_GLOBAL)
                            TEMP_GLOBAL = "TEMP"
                        end

                        SilentLogger.LogInfo("[Revert (Dev Tool)] Value should've been reverted to global ツ")
                    end
                }
            },

            Locals = {
                Type = {
                    hash = J("SN_Editor_LocalsType"),
                    name = "Type",
                    type = eFeatureType.Combo,
                    desc = "Select the desired local type.",
                    list = eTable.Editor.Locals.Types,
                    func = function(ftr)
                        local list  = eTable.Editor.Locals.Types
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Type (Locals)] Selected local type: %s ツ", list:GetName(index)))
                    end
                },

                Script = {
                    hash = J("SN_Editor_LocalsScript"),
                    name = "fm_mission_controller",
                    type = eFeatureType.InputText,
                    desc = "Input your script here."
                },

                Local = {
                    hash = J("SN_Editor_LocalsLocal"),
                    name = "10291",
                    type = eFeatureType.InputText,
                    desc = "Input your local here."
                },

                Value = {
                    hash = J("SN_Editor_LocalsValue"),
                    name = "4",
                    type = eFeatureType.InputText,
                    desc = "Input your value here."
                },

                Read = {
                    hash = J("SN_Editor_LocalsRead"),
                    name = "Read",
                    type = eFeatureType.Button,
                    desc = "Reads the entered local value.",
                    func = function()
                        SilentLogger.LogInfo("[Read (Dev Tool)] Value should've been read from local ツ")
                    end
                },

                Write = {
                    hash = J("SN_Editor_LocalsWrite"),
                    name = "Write",
                    type = eFeatureType.Button,
                    desc = "Writes the selected value to the entered local.",
                    func = function(type, hash, vLocal, value)
                        local SetValue = {
                            ["int"]   = ScriptLocal.SetInt,
                            ["float"] = ScriptLocal.SetFloat
                        }

                        SetValue[type](hash, vLocal, value)
                        SilentLogger.LogInfo("[Write (Dev Tool)] Value should've been written to local ツ")
                    end
                },

                Revert = {
                    hash = J("SN_Editor_LocalsRevert"),
                    name = "Revert",
                    type = eFeatureType.Button,
                    desc = "Reverts the previous value you've written to the entered local.",
                    func = function(type, hash, vLocal)
                        local SetValue = {
                            ["int"]   = ScriptLocal.SetInt,
                            ["float"] = ScriptLocal.SetFloat
                        }

                        if TEMP_LOCAL ~= "TEMP" then
                            SetValue[type](hash, vLocal, TEMP_LOCAL)
                            TEMP_LOCAL = "TEMP"
                        end

                        SilentLogger.LogInfo("[Revert (Dev Tool)] Value should've been reverted to local ツ")
                    end
                }
            },

            Stats = {
                From = {
                    hash = J("SN_Editor_StatsFrom"),
                    name = "From File",
                    type = eFeatureType.Toggle,
                    desc = "Allows to write the stats from the file.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[From File (Dev Tool)] Stats from file should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                    end
                },

                Type = {
                    hash = J("SN_Editor_StatsType"),
                    name = "Type",
                    type = eFeatureType.Combo,
                    desc = "Select the desired stat type.",
                    list = eTable.Editor.Stats.Types,
                    func = function(ftr)
                        local list  = eTable.Editor.Stats.Types
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Type (Stats)] Selected stat type: %s ツ", list:GetName(index)))
                    end
                },

                Stat = {
                    hash = J("SN_Editor_StatsStat"),
                    name = "MPX_KILLS",
                    type = eFeatureType.InputText,
                    desc = "Input your stat here."
                },

                Value = {
                    hash = J("SN_Editor_StatsValue"),
                    name = "7777",
                    type = eFeatureType.InputText,
                    desc = "Input your value here."
                },

                Read = {
                    hash = J("SN_Editor_StatsRead"),
                    name = "Read",
                    type = eFeatureType.Button,
                    desc = "Reads the entered stat value.",
                    func = function()
                        SilentLogger.LogInfo("[Read (Dev Tool)] Value should've been read from stat ツ")
                    end
                },

                Write = {
                    hash = J("SN_Editor_StatsWrite"),
                    name = "Write",
                    type = eFeatureType.Button,
                    desc = "Writes the selected value to the entered stat.",
                    func = function(type, hash, value)
                        local SetValue = {
                            ["int"]   = Stats.SetInt,
                            ["float"] = Stats.SetFloat,
                            ["bool"]  = Stats.SetBool
                        }

                        if type == "int" then
                            if math.abs(value) <= INT32_MAX then
                                SetValue[type](hash, value)
                                return
                            end

                            local loops     = math.floor(math.abs(value) / INT32_MAX)
                            local remainder = math.abs(value) - (loops * INT32_MAX)
                            local sign      = (value < 0) and -1 or 1

                            for i = 1, loops do
                                eNative.STATS.STAT_INCREMENT(hash, sign * INT32_MAX + .0)
                            end

                            eNative.STATS.STAT_INCREMENT(hash, sign * remainder + .0)
                        else
                            SetValue[type](hash, value)
                        end

                        SilentLogger.LogInfo("[Write (Dev Tool)] Value should've been written to stat ツ")
                    end
                },

                Revert = {
                    hash = J("SN_Editor_StatsRevert"),
                    name = "Revert",
                    type = eFeatureType.Button,
                    desc = "Reverts the previous value you've written to the entered stat.",
                    func = function(type, hash)
                        local SetValue = {
                            ["int"]   = Stats.SetInt,
                            ["float"] = Stats.SetFloat,
                            ["bool"]  = Stats.SetBool
                        }

                        if TEMP_STAT ~= "TEMP" then
                            SetValue[type](hash, TEMP_STAT)
                            TEMP_STAT = "TEMP"
                        end

                        SilentLogger.LogInfo("[Revert (Dev Tool)] Value should've been reverted to stat ツ")
                    end
                },

                File = {
                    hash = J("SN_Editor_StatsFile"),
                    name = "File",
                    type = eFeatureType.Combo,
                    desc = "Select the desired stat file.",
                    list = eTable.Editor.Stats.Files,
                    func = function(ftr)
                        local list  = eTable.Editor.Stats.Files
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[File (Dev Tool)] Selected stats file: %s ツ", (list:GetName(index) == "") and "Empty" or list:GetName(index)))
                    end
                },

                WriteAll = {
                    hash = J("SN_Editor_StatsWriteAll"),
                    name = "Write",
                    type = eFeatureType.Button,
                    desc = "Writes all the stats from the selected file.",
                    func = function(file)
                        local path = F("%s\\%s.json", STATS_DIR, file)

                        if FileMgr.DoesFileExist(path) then
                            local json = Json.DecodeFromFile(path)

                            for stat, value in pairs(json.stats) do
                                if stat:sub(1, 3) == "MPX" then
                                    stat = stat:gsub("MPX", F("MP%d", eStat.MPPLY_LAST_MP_CHAR:Get()))
                                end

                                if type(value) == "number" then
                                    if math.type(value) == "integer" then
                                        if math.abs(value) <= INT32_MAX then
                                            Stats.SetInt(J(stat), value)
                                            return
                                        end

                                        local loops     = math.floor(math.abs(value) / INT32_MAX)
                                        local remainder = math.abs(value) - (loops * INT32_MAX)
                                        local sign      = (value < 0) and -1 or 1

                                        for i = 1, loops do
                                            eNative.STATS.STAT_INCREMENT(J(stat), sign * INT32_MAX + .0)
                                        end

                                        eNative.STATS.STAT_INCREMENT(J(stat), sign * remainder + .0)
                                    else
                                        Stats.SetFloat(J(stat), value)
                                    end
                                elseif type(value) == "boolean" then
                                    Stats.SetBool(J(stat), value)
                                end
                            end

                            SilentLogger.LogInfo(F("[Write All (Dev Tool)] Stats from «%s» file should've been written ツ", file))
                            return
                        end

                        SilentLogger.LogError(F("[Write All (Dev Tool)] Stats file «%s» doesn't exist ツ", (file == "") and "Empty" or file))
                    end
                },

                Remove = {
                    hash = J("SN_Editor_StatsRemove"),
                    name = "Remove",
                    type = eFeatureType.Button,
                    desc = "Removes the selected stats file.",
                    func = function(file)
                        local path = F("%s\\%s.json", STATS_DIR, file)

                        if FileMgr.DoesFileExist(path) then
                            FileMgr.DeleteFile(path)
                            Helper.RefreshFiles()
                            SilentLogger.LogInfo(F("[Remove (Dev Tool)] Stats file «%s» should've been removed ツ", file))
                            return
                        end

                        SilentLogger.LogError(F("[Remove (Dev Tool)] Stats file «%s» doesn't exist ツ", (file == "") and "Empty" or file))
                    end
                },

                Refresh = {
                    hash = J("SN_Editor_StatsRefresh"),
                    name = "Refresh",
                    type = eFeatureType.Button,
                    desc = "Refreshes the list of stats files.",
                    func = function()
                        Helper.RefreshFiles()
                        SilentLogger.LogInfo("[Refresh (Dev Tool)] Stats files list should've been refreshed ツ")
                    end
                },

                Copy = {
                    hash = J("SN_Editor_StatsCopy"),
                    name = "Copy Folder Path",
                    type = eFeatureType.Button,
                    desc = "Copies the stats folder path to the clipboard.",
                    func = function()
                        FileMgr.CreateStatsDir()
                        Helper.RefreshFiles()
                        ImGui.SetClipboardText(STATS_DIR)
                        SilentLogger.LogInfo("[Copy (Dev Tool)] Stats folder path should've been copied ツ")
                    end
                },

                Generate = {
                    hash = J("SN_Editor_StatsGenerate"),
                    name = "Generate Example File",
                    type = eFeatureType.Button,
                    desc = "Generates the example stats file.",
                    func = function()
                        FileMgr.CreateStatsDir(true)
                        Helper.RefreshFiles()
                        SilentLogger.LogInfo("[Generate (Dev Tool)] Example stats file should've been generated ツ")
                    end
                }
            },

            PackedStats = {
                Range = {
                    hash = J("SN_Editor_PackedStatsRange"),
                    name = "Range",
                    type = eFeatureType.Toggle,
                    desc = "Allows to set a range of packed stats.",
                    func = function(ftr)
                        SilentLogger.LogInfo(F("[Range (Packed Stats)] Range should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                    end
                },

                Type = {
                    hash = J("SN_Editor_PackedStatsType"),
                    name = "Type",
                    type = eFeatureType.Combo,
                    desc = "Select the desired packed stat type.",
                    list = eTable.Editor.PackedStats.Types,
                    func = function(ftr)
                        local list  = eTable.Editor.PackedStats.Types
                        local index = list[ftr:GetListIndex() + 1].index
                        SilentLogger.LogInfo(F("[Type (Packed Stats)] Selected packed stat type: %s ツ", list:GetName(index)))
                    end
                },

                PackedStat = {
                    hash = J("SN_Editor_PackedStatsPackedStat"),
                    name = "22050",
                    type = eFeatureType.InputText,
                    desc = "Input your packed stat here."
                },

                Value = {
                    hash = J("SN_Editor_PackedStatsValue"),
                    name = "5",
                    type = eFeatureType.InputText,
                    desc = "Input your value here."
                },

                Read = {
                    hash = J("SN_Editor_PackedStatsRead"),
                    name = "Read",
                    type = eFeatureType.Button,
                    desc = "Reads the entered packed stat value.",
                    func = function()
                        SilentLogger.LogInfo("[Read (Dev Tool)] Value should've been read from packed stat ツ")
                    end
                },

                Write = {
                    hash = J("SN_Editor_PackedStatsWrite"),
                    name = "Write",
                    type = eFeatureType.Button,
                    desc = "Writes the selected value to the entered packed stat.",
                    func = function(type, firstPStat, lastPStat, value)
                        local SetValue = {
                            ["int"]  = eNative.STATS.SET_PACKED_STAT_INT_CODE,
                            ["bool"] = eNative.STATS.SET_PACKED_STAT_BOOL_CODE
                        }

                        if lastPStat == nil then
                            SetValue[type](firstPStat, value, eStat.MPPLY_LAST_MP_CHAR:Get())
                            SilentLogger.LogInfo("[Write (Dev Tool)] Value should've been written to packed stat ツ")
                            return
                        end

                        for i = firstPStat, lastPStat do
                            SetValue[type](i, value, eStat.MPPLY_LAST_MP_CHAR:Get())
                        end

                        TEMP_PSTAT = "TEMP"
                        SilentLogger.LogInfo("[Write (Dev Tool)] Value should've been written to packed stats ツ")
                    end
                },

                Revert = {
                    hash = J("SN_Editor_PackedStatsRevert"),
                    name = "Revert",
                    type = eFeatureType.Button,
                    desc = "Reverts the previous value you've written to the entered packed stat.",
                    func = function(type, packedStat)
                        local SetValue = {
                            ["int"]  = eNative.STATS.SET_PACKED_STAT_INT_CODE,
                            ["bool"] = eNative.STATS.SET_PACKED_STAT_BOOL_CODE
                        }

                        if TEMP_PSTAT ~= "TEMP" then
                            SetValue[type](packedStat, TEMP_PSTAT, eStat.MPPLY_LAST_MP_CHAR:Get())
                            TEMP_PSTAT = "TEMP"
                        end

                        SilentLogger.LogInfo("[Revert (Dev Tool)] Value should've been reverted to packed stat ツ")
                    end
                }
            }
        }
    },

    Settings = {
        Config = {
            Open = {
                hash = J("SN_Settings_CAutoOpen"),
                name = "Auto-Open Lua Tab",
                type = eFeatureType.Toggle,
                desc = "Automatically opens Lua Tab upon running the script.",
                func = function(ftr)
                    CONFIG.autoopen = ftr:IsToggled()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    if loggedAutoOpen then
                        loggedAutoOpen = false
                        return
                    end

                    SilentLogger.LogInfo(F("[Auto-Open Lua Tab (Settings)] Auto-open should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                end
            },

            Logging = {
                hash = J("SN_Settings_CLogging"),
                name = "Logging",
                type = eFeatureType.Combo,
                desc = "Disabled: no logging.\nSilent: logs only.\nEnabled: logs & toasts.",
                list = eTable.Settings.Logging,
                func = function(ftr)
                    CONFIG.logging = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list = eTable.Settings.Logging
                    SilentLogger.LogInfo(F("[Logging (Settings)] Selected logging level: %s ツ", list:GetName(CONFIG.logging)))
                end
            },

            Reset = {
                hash = J("SN_Settings_CReset"),
                name = "Reset",
                type = eFeatureType.Button,
                desc = "Resets the config to default.",
                func = function()
                    loggedAutoOpen          = true
                    loggedJinxScript        = true
                    loggedJinxScriptStop    = true
                    loggedUCayoPerico       = true
                    loggedUDiamondCasino    = true
                    loggedDummyPrevention   = true
                    FileMgr.ResetConfig()
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                    SilentLogger.LogInfo("[Reset (Settings)] Config should've been reset to default ツ")
                end
            },

            Copy = {
                hash = J("SN_Settings_CCopy"),
                name = "Copy Folder Path",
                type = eFeatureType.Button,
                desc = "Copies the config folder path to the clipboard.",
                func = function()
                    ImGui.SetClipboardText(CONFIG_DIR)
                    SilentLogger.LogInfo("[Copy Folder Path (Settings)] Config folder path should've been copied ツ")
                end
            },

            Discord = {
                hash = J("SN_Settings_CDiscord"),
                name = "Copy Discord Invite Link",
                type = eFeatureType.Button,
                desc = "Copies Discord server invite link to your clipboard.",
                func = function()
                    ImGui.SetClipboardText(DISCORD)
                    SilentLogger.LogInfo("[Copy Discord Invite Link (Settings)] Discord server invite link should've been copied ツ")
                end
            }
        },

        Translation = {
            File = {
                hash = J("SN_Settings_TFile"),
                name = "Language",
                type = eFeatureType.Combo,
                desc = "Select the desired translation.",
                list = eTable.Settings.Languages,
                func = function(ftr)
                    local list      = eTable.Settings.Languages
                    local index     = list[ftr:GetListIndex() + 1].index
                    CONFIG.language = list:GetName(index)
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                    SilentLogger.LogInfo(F("[Language (Settings)] Selected language: %s ツ", list:GetName(index)))
                end
            },

            Load = {
                hash = J("SN_Settings_TLoad"),
                name = "Load",
                type = eFeatureType.Button,
                desc = "Loads the selected translation.",
                func = function(file)
                    local path = F("%s\\%s.json", TRANS_DIR, file)

                    if FileMgr.DoesFileExist(path) then
                        Script.Translate(path)
                        SilentLogger.LogInfo(F("[Load (Settings)] Translation «%s» should've been loaded ツ", file))
                        return
                    else
                        SilentLogger.LogError(F("[Load (Settings)] Translation «%s» doesn't exist ツ", file))
                    end

                    CONFIG.language = "EN"
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    Helper.RefreshFiles()
                    Script.LoadDefaultTranslation()
                end
            },

            Remove = {
                hash = J("SN_Settings_TRemove"),
                name = "Remove",
                type = eFeatureType.Button,
                desc = "Removes the selected translation.",
                func = function(file)
                    local path = F("%s\\%s.json", TRANS_DIR, file)

                    if file == "EN" then
                        SilentLogger.LogError("[Remove (Settings)] You cannot remove default translation ツ")
                        return
                    end

                    if FileMgr.DoesFileExist(path) then
                        FileMgr.DeleteFile(path)
                        SilentLogger.LogInfo(F("[Remove (Settings)] Translation «%s» should've been removed ツ", file))
                    else
                        SilentLogger.LogError(F("[Remove (Settings)] Translation «%s» doesn't exist ツ", file))
                    end

                    CONFIG.language = "EN"
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    Helper.RefreshFiles()
                    Script.LoadDefaultTranslation()
                end
            },

            Refresh = {
                hash = J("SN_Settings_TRefresh"),
                name = "Refresh",
                type = eFeatureType.Button,
                desc = "Refreshes the list of translations.",
                func = function()
                    Helper.RefreshFiles()
                    SilentLogger.LogInfo("[Refresh (Settings)] Translations list should've been refreshed ツ")
                end
            },

            Export = {
                hash = J("SN_Settings_TExport"),
                name = "Export",
                type = eFeatureType.Button,
                desc = "Exports the current translation to the file.",
                func = function(file)
                    FileMgr.ExportTranslation(file)
                    SilentLogger.LogInfo(F("[Export (Settings)] Translation «%s» should've been exported ツ", file))
                end
            },

            Copy = {
                hash = J("SN_Settings_TCopy"),
                name = "Copy Folder Path",
                type = eFeatureType.Button,
                desc = "Copies the translations folder path to the clipboard.",
                func = function()
                    ImGui.SetClipboardText(TRANS_DIR)
                    SilentLogger.LogInfo("[Copy Folder Path (Settings)] Translations folder path should've been copied ツ")
                end
            }
        },

        Collab = {
            JinxScript = {
                Toggle = {
                    hash = J("SN_Settings_CJinxScriptToggle"),
                    name = "JinxScript",
                    type = eFeatureType.Toggle,
                    desc = "If enabled, JinxScript will help speed up some processes.",
                    func = function(ftr)
                        CONFIG.collab.jinxscript.enabled = ftr:IsToggled()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                        if loggedJinxScript then
                            loggedJinxScript = false
                            return
                        end

                        SilentLogger.LogInfo(F("[JinxScript (Settings)] JinxScript collab should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                    end
                },

                Discord = {
                    hash = J("SN_Settings_CJinxScriptDiscord"),
                    name = "Discord",
                    type = eFeatureType.Button,
                    desc = "Copies JinxScript Discord server invite link to your clipboard.",
                    func = function()
                        ImGui.SetClipboardText("https://discord.gg/hjs5S93kQv")
                        SilentLogger.LogInfo("[Discord (Settings)] JinxScript Discord server invite link should've been copied ツ")
                    end
                },

                Stop = {
                    hash = J("SN_Settings_CJinxScriptStop"),
                    name = "Auto-Stop JinxScript",
                    type = eFeatureType.Toggle,
                    desc = "Automatically stops JinxScript after using it in collab's features.",
                    func = function(ftr)
                        CONFIG.collab.jinxscript.autostop = ftr:IsToggled()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                        if loggedJinxScriptStop then
                            loggedJinxScriptStop = false
                            return
                        end

                        SilentLogger.LogInfo(F("[Auto-Stop JinxScript (Settings)] Auto-Stop JinxScript should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                    end
                }
            }
        },

        InstantFinish = {
            Agency = {
                hash = J("SN_Settings_IAgency"),
                name = "Agency",
                type = eFeatureType.Combo,
                desc = "Old: slower, works for all players, saves the preps.\nNew: faster, works for most players, resets the preps.",
                list = eTable.Settings.InstantFinishes,
                func = function(ftr)
                    CONFIG.instant_finish.agency = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list  = eTable.Settings.InstantFinishes
                    local index = list[ftr:GetListIndex() + 1].index
                    SilentLogger.LogInfo(F("[Agency (Settings)] Selected instant finish method: %s ツ", list:GetName(ftr:GetListIndex())))
                end
            },

            Apartment = {
                hash = J("SN_Settings_IApartment"),
                name = "Apartment",
                type = eFeatureType.Combo,
                desc = "Old: slower, works for all players, saves the preps, doesn't work for preps.\nNew: faster, works for most players, resets the preps, works for preps.",
                list = eTable.Settings.InstantFinishes,
                func = function(ftr)
                    CONFIG.instant_finish.apartment = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list = eTable.Settings.InstantFinishes
                    local index = list[ftr:GetListIndex() + 1].index
                    SilentLogger.LogInfo(F("[Apartment (Settings)] Selected instant finish method: %s ツ", list:GetName(index)))
                end
            },

            AutoShop = {
                hash = J("SN_Settings_IAutoShop"),
                name = "Auto Shop",
                type = eFeatureType.Combo,
                desc = "Old: slower, works for all players, saves the preps.\nNew: faster, works for most players, resets the preps.",
                list = eTable.Settings.InstantFinishes,
                func = function(ftr)
                    CONFIG.instant_finish.auto_shop = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list  = eTable.Settings.InstantFinishes
                    local index = list[ftr:GetListIndex() + 1].index
                    SilentLogger.LogInfo(F("[Auto Shop (Settings)] Selected instant finish method: %s ツ", list:GetName(index)))
                end
            },

            CayoPerico = {
                hash = J("SN_Settings_ICayoPerico"),
                name = "Cayo Perico",
                type = eFeatureType.Combo,
                desc = "Old: slower, works for all players, saves the preps.\nNew: faster, works for most players, resets the preps.",
                list = eTable.Settings.InstantFinishes,
                func = function(ftr)
                    CONFIG.instant_finish.cayo_perico = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list = eTable.Settings.InstantFinishes
                    local index = list[ftr:GetListIndex() + 1].index
                    SilentLogger.LogInfo(F("[Cayo Perico (Settings)] Selected instant finish method: %s ツ", list:GetName(index)))
                end
            },

            DiamondCasino = {
                hash = J("SN_Settings_IDiamondCasino"),
                name = "Diam. Casino",
                type = eFeatureType.Combo,
                desc = "Old: slower, works for all players, saves the preps.\nNew: faster, works for most players, resets the preps.",
                list = eTable.Settings.InstantFinishes,
                func = function(ftr)
                    CONFIG.instant_finish.diamond_casino = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list = eTable.Settings.InstantFinishes
                    local index = list[ftr:GetListIndex() + 1].index
                    SilentLogger.LogInfo(F("[Diamond Casino (Settings)] Selected instant finish method: %s ツ", list:GetName(index)))
                end
            },

            Doomsday = {
                hash = J("SN_Settings_IDoomsday"),
                name = "Doomsday",
                type = eFeatureType.Combo,
                desc = "Old: slower, works for all players, saves the preps, doesn't work for Act III.\nNew: faster, works for most players, resets the preps, does work for Act III.",
                list = eTable.Settings.InstantFinishes,
                func = function(ftr)
                    CONFIG.instant_finish.doomsday = ftr:GetListIndex()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    local list  = eTable.Settings.InstantFinishes
                    local index = list[ftr:GetListIndex() + 1].index
                    SilentLogger.LogInfo(F("[Doomsday (Settings)] Selected instant finish method: %s ツ", list:GetName(index)))
                end
            }
        },

        UnlockAllPoi = {
            CayoPerico = {
                hash = J("SN_Settings_UCayoPerico"),
                name = "Cayo Perico",
                type = eFeatureType.Toggle,
                desc = "If enabled, «Apply & Complete Preps» will automatically unlock all points of interest.",
                func = function(ftr)
                    CONFIG.unlock_all_poi.cayo_perico = ftr:IsToggled()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    if loggedUCayoPerico then
                        loggedUCayoPerico = false
                        return
                    end

                    SilentLogger.LogInfo(F("[Cayo Perico (Settings)] Unlock All POI should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                end
            },

            DiamondCasino = {
                hash = J("SN_Settings_UDiamondCasino"),
                name = "Diamond Casino",
                type = eFeatureType.Toggle,
                desc = "If enabled, «Apply & Complete Preps» will automatically unlock all points of interest.",
                func = function(ftr)
                    CONFIG.unlock_all_poi.diamond_casino = ftr:IsToggled()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    if loggedUDiamondCasino then
                        loggedUDiamondCasino = false
                        return
                    end

                    SilentLogger.LogInfo(F("[Diamond Casino (Settings)] Unlock All POI should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                end
            }
        },

        EasyMoney = {
            Prevention = {
                hash = J("SN_Settings_Prevention"),
                name = "Dummy Prevention",
                type = eFeatureType.Toggle,
                desc = "Prevents enabling multiple «Easy Money» loops simultaneously.",
                func = function(ftr)
                    CONFIG.easy_money.dummy_prevention = ftr:IsToggled()
                    FileMgr.SaveConfig(CONFIG)
                    CONFIG = Json.DecodeFromFile(CONFIG_PATH)

                    if loggedDummyPrevention then
                        loggedDummyPrevention = false
                        return
                    end

                    SilentLogger.LogInfo(F("[Dummy Prevention (Settings)] Prevention should've been %s ツ", (ftr:IsToggled()) and "enabled" or "disabled"))
                end
            },

            Delay = {
                _5k = {
                    hash = J("SN_Settings_5k"),
                    name = "5k Loop",
                    type = eFeatureType.SliderFloat,
                    desc = "Changes the delay between transactions. Try to increase if you get transaction errors.",
                    lims = { 1.0, 5.0 },
                    func = function(ftr)
                        CONFIG.easy_money.delay._5k = ftr:GetFloatValue()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                        SilentLogger.LogInfo("[5k Loop (Settings)] Delay should've been changed ツ")
                    end
                },

                _50k = {
                    hash = J("SN_Settings_50k"),
                    name = "50k Loop",
                    type = eFeatureType.SliderFloat,
                    desc = "Changes the delay between transactions. Try to increase if you get transaction errors.",
                    lims = { 0.333, 5.0 },
                    func = function(ftr)
                       CONFIG.easy_money.delay._50k = ftr:GetFloatValue()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                        SilentLogger.LogInfo("[50k Loop (Settings)] Delay should've been changed ツ")
                    end
                },

                _100k = {
                    hash = J("SN_Settings_100k"),
                    name = "100k Loop",
                    type = eFeatureType.SliderFloat,
                    desc = "Changes the delay between transactions. Try to increase if you get transaction errors.",
                    lims = { 0.333, 5.0 },
                    func = function(ftr)
                        CONFIG.easy_money.delay._100k = ftr:GetFloatValue()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                        SilentLogger.LogInfo("[100k Loop (Settings)] Delay should've been changed ツ")
                    end
                },

                _180k = {
                    hash = J("SN_Settings_180k"),
                    name = "180k Loop",
                    type = eFeatureType.SliderFloat,
                    desc = "Changes the delay between transactions. Try to increase if you get transaction errors.",
                    lims = { 0.333, 5.0 },
                    func = function(ftr)
                        CONFIG.easy_money.delay._180k = ftr:GetFloatValue()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                        SilentLogger.LogInfo("[180k Loop (Settings)] Delay should've been changed ツ")
                    end
                },

                _300k = {
                    hash = J("SN_Settings_300k"),
                    name = "300k Loop",
                    type = eFeatureType.SliderFloat,
                    desc = "Changes the delay between transactions. Try to increase if you get transaction errors.",
                    lims = { 1.0, 5.0 },
                    func = function(ftr)
                        CONFIG.easy_money.delay._300k = ftr:GetFloatValue()
                        FileMgr.SaveConfig(CONFIG)
                        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
                        SilentLogger.LogInfo("[300k Loop (Settings)] Delay should've been changed ツ")
                    end
                }
            }
        }
    }
}

--#endregion

--#region Features

apartmentPlayers = {
    eFeature.Heist.Apartment.Cuts.Player1,
    eFeature.Heist.Apartment.Cuts.Player2,
    eFeature.Heist.Apartment.Cuts.Player3,
    eFeature.Heist.Apartment.Cuts.Player4
}

cayoPreps = {
    eFeature.Heist.CayoPerico.Preps.Difficulty,
    eFeature.Heist.CayoPerico.Preps.Approach,
    eFeature.Heist.CayoPerico.Preps.Loadout,
    eFeature.Heist.CayoPerico.Preps.Target.Primary,
    eFeature.Heist.CayoPerico.Preps.Target.Secondary.Compound,
    eFeature.Heist.CayoPerico.Preps.Target.Amount.Compound,
    eFeature.Heist.CayoPerico.Preps.Target.Amount.Arts,
    eFeature.Heist.CayoPerico.Preps.Target.Secondary.Island,
    eFeature.Heist.CayoPerico.Preps.Target.Amount.Island,
    eFeature.Heist.CayoPerico.Preps.Target.Value.Cash,
    eFeature.Heist.CayoPerico.Preps.Target.Value.Weed,
    eFeature.Heist.CayoPerico.Preps.Target.Value.Coke,
    eFeature.Heist.CayoPerico.Preps.Target.Value.Gold,
    eFeature.Heist.CayoPerico.Preps.Target.Value.Arts
}

cayoPlayers = {
    eFeature.Heist.CayoPerico.Cuts.Player1,
    eFeature.Heist.CayoPerico.Cuts.Player2,
    eFeature.Heist.CayoPerico.Cuts.Player3,
    eFeature.Heist.CayoPerico.Cuts.Player4
}

diamondPreps = {
    eFeature.Heist.DiamondCasino.Preps.Difficulty,
    eFeature.Heist.DiamondCasino.Preps.Approach,
    eFeature.Heist.DiamondCasino.Preps.Gunman,
    eFeature.Heist.DiamondCasino.Preps.Driver,
    eFeature.Heist.DiamondCasino.Preps.Hacker,
    eFeature.Heist.DiamondCasino.Preps.Masks,
    eFeature.Heist.DiamondCasino.Preps.Guards,
    eFeature.Heist.DiamondCasino.Preps.Keycards,
    eFeature.Heist.DiamondCasino.Preps.Target
}

diamondPlayers = {
    eFeature.Heist.DiamondCasino.Cuts.Player1,
    eFeature.Heist.DiamondCasino.Cuts.Player2,
    eFeature.Heist.DiamondCasino.Cuts.Player3,
    eFeature.Heist.DiamondCasino.Cuts.Player4
}

doomsdayPlayers = {
    eFeature.Heist.Doomsday.Cuts.Player1,
    eFeature.Heist.Doomsday.Cuts.Player2,
    eFeature.Heist.Doomsday.Cuts.Player3,
    eFeature.Heist.Doomsday.Cuts.Player4
}

salvageSlotsRobbery = {
    eFeature.Heist.SalvageYard.Slot1.Robbery,
    eFeature.Heist.SalvageYard.Slot2.Robbery,
    eFeature.Heist.SalvageYard.Slot3.Robbery
}

salvageSlotsVehicle = {
    eFeature.Heist.SalvageYard.Slot1.Vehicle,
    eFeature.Heist.SalvageYard.Slot2.Vehicle,
    eFeature.Heist.SalvageYard.Slot3.Vehicle
}

salvageSlotsMod = {
    eFeature.Heist.SalvageYard.Slot1.Modification,
    eFeature.Heist.SalvageYard.Slot2.Modification,
    eFeature.Heist.SalvageYard.Slot3.Modification
}

salvageSlotsKeep = {
    eFeature.Heist.SalvageYard.Slot1.Keep,
    eFeature.Heist.SalvageYard.Slot2.Keep,
    eFeature.Heist.SalvageYard.Slot3.Keep
}

salvageSlotsApply = {
    eFeature.Heist.SalvageYard.Slot1.Apply,
    eFeature.Heist.SalvageYard.Slot2.Apply,
    eFeature.Heist.SalvageYard.Slot3.Apply
}

salvageSlotsAvailable = {
    eFeature.Heist.SalvageYard.Misc.Availability.Slot1,
    eFeature.Heist.SalvageYard.Misc.Availability.Slot2,
    eFeature.Heist.SalvageYard.Misc.Availability.Slot3
}

salvageSlotsValue = {
    eFeature.Heist.SalvageYard.Payout.Slot1,
    eFeature.Heist.SalvageYard.Payout.Slot2,
    eFeature.Heist.SalvageYard.Payout.Slot3
}

bunkerStats = {
    eFeature.Business.Bunker.Stats.SellMade,
    eFeature.Business.Bunker.Stats.SellUndertaken,
    eFeature.Business.Bunker.Stats.Earnings
}

bunkerToggles = {
    eFeature.Business.Bunker.Stats.NoSell,
    eFeature.Business.Bunker.Stats.NoEarnings
}

hangarStats = {
    eFeature.Business.Hangar.Stats.BuyMade,
    eFeature.Business.Hangar.Stats.BuyUndertaken,
    eFeature.Business.Hangar.Stats.SellMade,
    eFeature.Business.Hangar.Stats.SellUndertaken,
    eFeature.Business.Hangar.Stats.Earnings
}

hangarToggles = {
    eFeature.Business.Hangar.Stats.NoBuy,
    eFeature.Business.Hangar.Stats.NoSell,
    eFeature.Business.Hangar.Stats.NoEarnings
}

nightclubStats = {
    eFeature.Business.Nightclub.Stats.SellMade,
    eFeature.Business.Nightclub.Stats.Earnings
}

nightclubToggles = {
    eFeature.Business.Nightclub.Stats.NoSell,
    eFeature.Business.Nightclub.Stats.NoEarnings
}

specialSaleToggles = {
    eFeature.Business.CrateWarehouse.Sale.NoXp,
    eFeature.Business.CrateWarehouse.Sale.NoCrateback
}

specialStats = {
    eFeature.Business.CrateWarehouse.Stats.BuyMade,
    eFeature.Business.CrateWarehouse.Stats.BuyUndertaken,
    eFeature.Business.CrateWarehouse.Stats.SellMade,
    eFeature.Business.CrateWarehouse.Stats.SellUndertaken,
    eFeature.Business.CrateWarehouse.Stats.Earnings
}

specialToggles = {
    eFeature.Business.CrateWarehouse.Stats.NoBuy,
    eFeature.Business.CrateWarehouse.Stats.NoSell,
    eFeature.Business.CrateWarehouse.Stats.NoEarnings
}

easyLoops = {
    eFeature.Money.EasyMoney.Freeroam._5k,
    eFeature.Money.EasyMoney.Freeroam._50k,
    eFeature.Money.EasyMoney.Freeroam._100k,
    eFeature.Money.EasyMoney.Freeroam._180k,
    eFeature.Money.EasyMoney.Property._300k
}

devStatsDefault = {
    eFeature.Dev.Editor.Stats.Type,
    eFeature.Dev.Editor.Stats.Stat,
    eFeature.Dev.Editor.Stats.Value,
    eFeature.Dev.Editor.Stats.Read,
    eFeature.Dev.Editor.Stats.Write,
    eFeature.Dev.Editor.Stats.Revert
}

devStatsFromFile = {
    eFeature.Dev.Editor.Stats.File,
    eFeature.Dev.Editor.Stats.WriteAll,
    eFeature.Dev.Editor.Stats.Remove,
    eFeature.Dev.Editor.Stats.Refresh,
    eFeature.Dev.Editor.Stats.Copy,
    eFeature.Dev.Editor.Stats.Generate
}

settingsInstantFinishes = {
    eFeature.Settings.InstantFinish.Agency,
    eFeature.Settings.InstantFinish.Apartment,
    eFeature.Settings.InstantFinish.AutoShop,
    eFeature.Settings.InstantFinish.CayoPerico,
    eFeature.Settings.InstantFinish.DiamondCasino,
    eFeature.Settings.InstantFinish.Doomsday
}

settingsEasyDelays = {
    eFeature.Settings.EasyMoney.Delay._5k,
    eFeature.Settings.EasyMoney.Delay._50k,
    eFeature.Settings.EasyMoney.Delay._100k,
    eFeature.Settings.EasyMoney.Delay._180k,
    eFeature.Settings.EasyMoney.Delay._300k
}

loggedSoloLaunch        = false
loggedApartmentBonus    = false
loggedCayoBag           = false
loggedCayoCrew          = false
loggedDiamondAuto       = false
loggedDiamondCrew       = false
loggedSalvageSetup      = false
loggedSalvageClaim      = false
loggedBunkerPrice       = false
loggedHangarPrice       = false
loggedHangarSupplier    = false
loggedHangarCooldown    = false
loggedNightclubPrice    = false
loggedNightclubCooldown = false
loggedSpecialPrice      = false
loggedSpecialSupplier   = false
loggedSpecialCooldown   = false
loggedCasinoLimits      = false
logged5kLoop            = false
logged50kLoop           = false
logged100kLoop          = false
logged180kLoop          = false
logged300kLoop          = false
loggedAutoOpen          = true
loggedJinxScript        = true
loggedJinxScriptStop    = true
loggedUCayoPerico       = true
loggedUDiamondCasino    = true
loggedDummyPrevention   = true

--#endregion

--#region ClickGUI

_RenderFeature = ClickGUI.RenderFeature

function ClickGUI.RenderFeature(feature)
    _RenderFeature(feature.hash)
end

--#endregion

--#region Tab

_addFeature = Tab.AddFeature

function Tab:AddFeature(feature)
    _addFeature(self, feature.hash)
end

--#endregion

--#region EventMgr

logTransactions = false

function EventMgr.OnPresent()
    EventMgr.RegisterHandler(eLuaEvent.ON_PRESENT, function()
        if FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.LogTransactions) then
            if FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.LogTransactions):IsToggled() then
                logTransactions = true
                SetShouldUnload()
            end
        end
    end)
end

function EventMgr.OnUnload()
    EventMgr.RegisterHandler(eLuaEvent.ON_UNLOAD, function()
        if logTransactions then
            SilentLogger.LogError(F("«Log Transactions» is enabled. %s is unloading... ツ", SCRIPT_NAME))
        end

        SilentLogger.LogInfo(F("%s has unloaded ツ", SCRIPT_NAME))
    end)
end

EventMgr.OnPresent()

EventMgr.OnUnload()

--#endregion

--#region FeatureMgr

_GetFeature          = FeatureMgr.GetFeature
_GetFeatureListIndex = FeatureMgr.GetFeatureListIndex
_GetFeatureInt       = FeatureMgr.GetFeatureInt
_AddFeature          = FeatureMgr.AddFeature

function FeatureMgr.GetFeature(feature)
    return _GetFeature(feature.hash)
end

function FeatureMgr.GetFeatureByHash(hash)
    return _GetFeature(hash)
end

function FeatureMgr.GetFeatureListIndex(feature)
    return _GetFeatureListIndex(feature.hash)
end

function FeatureMgr.GetFeatureInt(feature)
    return _GetFeatureInt(feature.hash)
end

function FeatureMgr.GetFeatureBool(feature)
    return _GetFeature(feature.hash):IsToggled()
end

featureHashes = {}

function FeatureMgr.AddFeature(feature, callback)
    _AddFeature(feature.hash, feature.name, feature.type, feature.desc, function(f)
        if callback then
            callback(f)
        elseif feature.func then
            feature.func(f)
        end
    end)

    if feature.list then
        FeatureMgr.GetFeature(feature):SetList(feature.list:GetNames())
    end

    if feature.defv then
        FeatureMgr.GetFeature(feature):SetDefaultValue(feature.defv)
    end

    if feature.lims then
        FeatureMgr.GetFeature(feature):SetLimitValues(U(feature.lims))
    end

    if feature.step then
        FeatureMgr.GetFeature(feature):SetStepSize(feature.step)
    end

    if feature.defv or feature.lims or feature.step then
        FeatureMgr.GetFeature(feature):Reset()
    end

    I(featureHashes, feature.hash)

    return FeatureMgr.GetFeature(feature)
end

function FeatureMgr.AddLoop(feature, onEnable, onDisable)
    local state = false

    FeatureMgr.AddFeature(feature, function(f)
        if f:IsToggled() then
            if not state then
                state = true

                Script.RegisterLooped(function()
                    if ShouldUnload() or not f:IsToggled() then
                        return
                    end

                    if onEnable then
                        onEnable(f)
                        Script.Yield()
                    elseif feature.func then
                        feature.func(f)
                    end

                    Script.Yield()
                end)
            end
        elseif onDisable and state then
            onDisable(f)
            state = false
        end
    end)

    return FeatureMgr.GetFeature(feature)
end

--#endregion

--#region Json

-- Modified version of https://github.com/rxi/json.lua

Json = {}

local Encode

local escapeCharMap = {
    [ "\\" ] = "\\",
    [ "\"" ] = "\"",
    [ "\b" ] = "b",
    [ "\f" ] = "f",
    [ "\n" ] = "n",
    [ "\r" ] = "r",
    [ "\t" ] = "t",
}

local escapeCharMapInv = { [ "/" ] = "/" }

for k, v in pairs(escapeCharMap) do
    escapeCharMapInv[v] = k
end

local function EscapeChar(c)
    return "\\" .. (escapeCharMap[c] or F("u%04x", c:byte()))
end

local function EncodeNil()
    return "null"
end

local function EncodeTable(val, stack)
    local res = {}
    stack = stack or {}

    -- Circular reference?
    if stack[val] then SilentLogger.LogError("circular reference") end

    stack[val] = true

    if rawget(val, 1) ~= nil or next(val) == nil then
        -- Treat as array -- check keys are valid and it is not sparse
        local n = 0
        for k in pairs(val) do
            if type(k) ~= "number" then
                SilentLogger.LogError("invalid table: mixed or invalid key types")
            end
            n = n + 1
        end
        if n ~= #val then
            SilentLogger.LogError("invalid table: sparse array")
        end
        -- Encode
        for i, v in ipairs(val) do
            I(res, Encode(v, stack))
        end
        stack[val] = nil
        return "[" .. table.concat(res, ",") .. "]"
    else
        -- Treat as an object
        for k, v in pairs(val) do
            if type(k) ~= "string" then
                SilentLogger.LogError("invalid table: mixed or invalid key types")
            end
            I(res, Encode(k, stack) .. ":" .. Encode(v, stack))
        end
        stack[val] = nil
        return "{" .. table.concat(res, ",") .. "}"
    end
end

local function EncodeString(val)
    return '"' .. val:gsub('[%z\1-\31\\"]', EscapeChar) .. '"'
end

local function EncodeNumber(val)
    -- Check for NaN, -inf and inf
    if val ~= val or val <= -math.huge or val >= math.huge then
        SilentLogger.LogError("unexpected number value '" .. S(val) .. "'")
    end
    return F("%.14g", val)
end

local typeFuncMap = {
    [ "nil"     ] = EncodeNil,
    [ "table"   ] = EncodeTable,
    [ "string"  ] = EncodeString,
    [ "number"  ] = EncodeNumber,
    [ "boolean" ] = S,
}

Encode = function(val, stack)
    local t = type(val)
    local f = typeFuncMap[t]
    if f then
        return f(val, stack)
    end
    SilentLogger.LogError("unexpected type '" .. t .. "'")
end

function Json.Encode(val, indent)
    indent = indent or "\t"
    local function EncodeValue(value, stack, currentIndent)
        local t = type(value)
        stack = stack or {}
        currentIndent = currentIndent or ""

        if t == "table" then
            if stack[value] then SilentLogger.LogError("circular reference") end
            stack[value] = true

            local res = {}
            local nextIndent = currentIndent .. indent

            if rawget(value, 1) ~= nil or next(value) == nil then
                -- Array
                for _, v in ipairs(value) do
                    I(res, nextIndent .. EncodeValue(v, stack, nextIndent))
                end
                stack[value] = nil
                return "[\n" .. table.concat(res, ",\n") .. "\n" .. currentIndent .. "]"
            else
                -- Object
                for k, v in pairs(value) do
                    I(res, nextIndent .. EncodeString(k) .. ": " .. EncodeValue(v, stack, nextIndent))
                end
                stack[value] = nil
                return "{\n" .. table.concat(res, ",\n") .. "\n" .. currentIndent .. "}"
            end
        else
            return Encode(value, stack)
        end
    end

    return EncodeValue(val)
end

local Parse

local function CreateSet(...)
    local res = {}
    for i = 1, select("#", ...) do
        res[select(i, ...)] = true
    end
    return res
end

local spaceChars = CreateSet(" ", "\t", "\r", "\n")
local delimChars = CreateSet(" ", "\t", "\r", "\n", "]", "}", ",")
local escapeChars = CreateSet("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals = CreateSet("true", "false", "null")

local literalMap = {
    ["true"] = true,
    ["false"] = false,
    ["null"] = nil,
}

local function NextChar(str, idx, set, negate)
    for i = idx, #str do
        if set[str:sub(i, i)] ~= negate then
            return i
        end
    end
    return #str + 1
end

local function DecodeError(str, idx, msg)
    local lineCount = 1
    local colCount = 1
    for i = 1, idx - 1 do
        colCount = colCount + 1
        if str:sub(i, i) == "\n" then
            lineCount = lineCount + 1
            colCount = 1
        end
    end
    SilentLogger.LogError(F("%s at line %d col %d", msg, lineCount, colCount))
end

local function CodepointToUtf8(n)
    local f = math.floor
    if n <= 0x7f then
        return string.char(n)
    elseif n <= 0x7ff then
        return string.char(f(n / 64) + 192, n % 64 + 128)
    elseif n <= 0xffff then
        return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
    elseif n <= 0x10ffff then
        return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128, f(n % 4096 / 64) + 128, n % 64 + 128)
    end
    SilentLogger.LogError(F("invalid unicode codepoint '%x'", n))
end

local function ParseUnicodeEscape(s)
    local n1 = N(s:sub(1, 4), 16)
    local n2 = N(s:sub(7, 10), 16)
    -- Surrogate pair?
    if n2 then
        return CodepointToUtf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
    else
        return CodepointToUtf8(n1)
    end
end

local function ParseString(str, i)
    local res = ""
    local j = i + 1
    local k = j

    while j <= #str do
        local x = str:byte(j)

        if x < 32 then
            DecodeError(str, j, "control character in string")
        elseif x == 92 then -- `\`: Escape
            res = res .. str:sub(k, j - 1)
            j = j + 1
            local c = str:sub(j, j)
            if c == "u" then
                local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                    or str:match("^%x%x%x%x", j + 1)
                    or DecodeError(str, j - 1, "invalid unicode escape in string")
                res = res .. ParseUnicodeEscape(hex)
                j = j + #hex
            else
                if not escapeChars[c] then
                    DecodeError(str, j - 1, "invalid escape char '" .. c .. "' in string")
                end
                res = res .. escapeCharMapInv[c]
            end
            k = j + 1
        elseif x == 34 then -- `"`: End of string
            res = res .. str:sub(k, j - 1)
            return res, j + 1
        end

        j = j + 1
    end

    DecodeError(str, i, "expected closing quote for string")
end

local function ParseNumber(str, i)
    local x = NextChar(str, i, delimChars)
    local s = str:sub(i, x - 1)
    local n = N(s)
    if not n then
        DecodeError(str, i, "invalid number '" .. s .. "'")
    end
    return n, x
end

local function ParseLiteral(str, i)
    local x = NextChar(str, i, delimChars)
    local word = str:sub(i, x - 1)
    if not literals[word] then
        DecodeError(str, i, "invalid literal '" .. word .. "'")
    end
    return literalMap[word], x
end

local function ParseArray(str, i)
    local res = {}
    local n = 1
    i = i + 1
    while 1 do
        local x
        i = NextChar(str, i, spaceChars, true)
        -- Empty / end of array?
        if str:sub(i, i) == "]" then
            i = i + 1
            break
        end
        -- Read token
        x, i = Parse(str, i)
        res[n] = x
        n = n + 1
        -- Next token
        i = NextChar(str, i, spaceChars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "]" then break end
        if chr ~= "," then DecodeError(str, i, "expected ']' or ','") end
    end
    return res, i
end

local function ParseObject(str, i)
    local res = {}
    i = i + 1
    while 1 do
        local key, val
        i = NextChar(str, i, spaceChars, true)
        -- Empty / end of object?
        if str:sub(i, i) == "}" then
            i = i + 1
            break
        end
        -- Read key
        if str:sub(i, i) ~= '"' then
            DecodeError(str, i, "expected string for key")
        end
        key, i = Parse(str, i)
        -- Read ':' delimiter
        i = NextChar(str, i, spaceChars, true)
        if str:sub(i, i) ~= ":" then
            DecodeError(str, i, "expected ':' after key")
        end
        i = NextChar(str, i + 1, spaceChars, true)
        -- Read value
        val, i = Parse(str, i)
        -- Set
        res[key] = val
        -- Next token
        i = NextChar(str, i, spaceChars, true)
        local chr = str:sub(i, i)
        i = i + 1
        if chr == "}" then break end
        if chr ~= "," then DecodeError(str, i, "expected '}' or ','") end
    end
    return res, i
end

local charFuncMap = {
    [ '"' ] = ParseString,
    [ "0" ] = ParseNumber,
    [ "1" ] = ParseNumber,
    [ "2" ] = ParseNumber,
    [ "3" ] = ParseNumber,
    [ "4" ] = ParseNumber,
    [ "5" ] = ParseNumber,
    [ "6" ] = ParseNumber,
    [ "7" ] = ParseNumber,
    [ "8" ] = ParseNumber,
    [ "9" ] = ParseNumber,
    [ "-" ] = ParseNumber,
    [ "t" ] = ParseLiteral,
    [ "f" ] = ParseLiteral,
    [ "n" ] = ParseLiteral,
    [ "[" ] = ParseArray,
    [ "{" ] = ParseObject,
}

Parse = function(str, idx)
    local chr = str:sub(idx, idx)
    local f = charFuncMap[chr]
    if f then
        return f(str, idx)
    end
    DecodeError(str, idx, "unexpected character '" .. chr .. "'")
end

function Json.Decode(str)
    if type(str) ~= "string" or str == "" then
        SilentLogger.LogError("expected non-empty string, got " .. S(str))
    end
    local res, idx = Parse(str, NextChar(str, 1, spaceChars, true))
    idx = NextChar(str, idx, spaceChars, true)
    if idx <= #str then
        DecodeError(str, idx, "trailing garbage")
    end
    return res
end

function Json.EncodeToFile(path, tbl)
    if FileMgr.DoesFileExist(path) then
        FileMgr.DeleteFile(path)
    end

    FileMgr.WriteFileContent(path, Json.Encode(tbl), false)
end

function Json.DecodeFromFile(path)
    if not FileMgr.DoesFileExist(path) then
       SilentLogger.LogError(F("File not found: %s", path))
    end

    return Json.Decode(FileMgr.ReadFileContent(path))
end

--#endregion

--#region FileMgr

function FileMgr.CreateConfig()
    if not FileMgr.DoesFileExist(CONFIG_DIR) then
        FileMgr.CreateDir(CONFIG_DIR)
    end

    if not FileMgr.DoesFileExist(CONFIG_PATH) then
        local config = {
            autoopen = false,
            logging  = 2,
            language = "EN",

            collab = {
                jinxscript = {
                    enabled  = true,
                    autostop = false
                }
            },

            instant_finish = {
                agency         = 1,
                apartment      = 0,
                auto_shop      = 1,
                cayo_perico    = 1,
                diamond_casino = 0,
                doomsday       = 1
            },

            unlock_all_poi = {
                cayo_perico    = true,
                diamond_casino = true
            },

            easy_money = {
                dummy_prevention = true,

                delay = {
                    _5k   = 1.5,
                    _50k  = 0.333,
                    _100k = 0.333,
                    _180k = 0.333,
                    _300k = 1.0
                }
            }
        }

        Json.EncodeToFile(CONFIG_PATH, config)
    end
end

function FileMgr.SaveConfig(config)
    Json.EncodeToFile(CONFIG_PATH, config)
end

function FileMgr.ResetConfig()
    if FileMgr.DoesFileExist(CONFIG_PATH) then
        FileMgr.DeleteFile(CONFIG_PATH)
    end

    FileMgr.CreateConfig()
end

function FileMgr.EnsureConfigKeys()
    if not CONFIG then
        FileMgr.ResetConfig()
        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
        SilentLogger.LogError("Config is missing something. Config reset ツ")
        return
    end

    local required         = { "autoopen", "logging", "language", "collab", "instant_finish", "unlock_all_poi", "easy_money" }
    local required_collab  = { "jinxscript" }
    local required_jinx    = { "enabled", "autostop" }
    local required_instant = { "agency", "apartment", "auto_shop", "cayo_perico", "diamond_casino", "doomsday" }
    local required_unlock  = { "cayo_perico", "diamond_casino" }
    local required_easy    = { "dummy_prevention", "delay" }
    local required_delay   = { "_5k", "_50k", "_100k", "_180k", "_300k" }

    local function HasKeys(tbl, keys)
        if type(tbl) ~= "table" then return false end

        for _, k in ipairs(keys) do
            if not tbl or tbl[k] == nil then return false end
        end

        return true
    end

    local missing = false

    if not HasKeys(CONFIG, required) then
        missing = true
    end

    if not HasKeys(CONFIG.collab, required_collab) then
        missing = true
    end

    if not HasKeys(CONFIG.collab.jinxscript, required_jinx) then
        missing = true
    end

    if not HasKeys(CONFIG.instant_finish, required_instant) then
        missing = true
    end

    if not HasKeys(CONFIG.unlock_all_poi, required_unlock) then
        missing = true
    end

    if not HasKeys(CONFIG.easy_money, required_easy) then
        missing = true
    end

    if not HasKeys(CONFIG.easy_money.delay, required_delay) then
        missing = true
    end

    if missing then
        FileMgr.ResetConfig()
        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
        SilentLogger.LogError("Config is missing something. Config reset ツ")
    end
end

function FileMgr.ExportTranslation(file)
    if not FileMgr.DoesFileExist(TRANS_DIR) then
        FileMgr.CreateDir(TRANS_DIR)
    end

    local path = F("%s\\%s.json", TRANS_DIR, file)

    if FileMgr.DoesFileExist(path) then
        FileMgr.DeleteFile(path)
    end

    local features = {}

    for _, hash in pairs(featureHashes) do
        local feature = FeatureMgr.GetFeatureByHash(hash)

        if feature then
            local name = feature:GetName(false)
            local desc = feature:GetDesc(false)

            if name and desc then
                local entry = {
                    name = name,
                    desc = desc
                }

                if feature:GetType() == eFeatureType.Combo then
                    local list = feature:GetList()
                    entry.list = {}

                    for _, item in ipairs(list) do
                        I(entry.list, item)
                    end
                end

                features[S(hash)] = entry
            end
        end
    end

    Json.EncodeToFile(path, features)
end

function FileMgr.CreateHeistPresetsDirs()
    if not FileMgr.DoesFileExist(CAYO_DIR) then
        FileMgr.CreateDir(CAYO_DIR)
    end

    if not FileMgr.DoesFileExist(DIAMOND_DIR) then
        FileMgr.CreateDir(DIAMOND_DIR)
    end
end

function FileMgr.CreateStatsDir(generateExample)
    if not FileMgr.DoesFileExist(STATS_DIR) then
        FileMgr.CreateDir(STATS_DIR)
    end

    if generateExample then
        local stats = {
            comment = "Example stats file.",

            stats = {
                MPX_H3OPT_APPROACH = 2,
                MPX_PLAYER_MENTAL_STATE = 99.9,
                MPPLY_CHAR_IS_BADSPORT = false
            }
        }

        local path = F("%s\\example.json", STATS_DIR)

        Json.EncodeToFile(path, stats)
    end
end

FileMgr.CreateConfig()

CONFIG = Json.DecodeFromFile(CONFIG_PATH)

FileMgr.EnsureConfigKeys()

--#endregion

--#region GTA

_ForceScriptHost = GTA.ForceScriptHost

function GTA.TeleportXYZ(x, y, z)
    local playerPed     = GTA.GetLocalPed()
    local playerVehicle = GTA.GetLocalVehicle()
    eNative.ENTITY.SET_ENTITY_COORDS_NO_OFFSET((playerVehicle ~= nil) and playerVehicle or playerPed, x, y, z, false, false, false)
end

function GTA.SimulatePlayerControl(action)
    eNative.PAD.ENABLE_CONTROL_ACTION(0, action, true)
    eNative.PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, action, 1.0)
    Script.Yield(25)
    eNative.PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, action, 1.0)
end

function GTA.SimulateFrontendControl(action)
    eNative.PAD.ENABLE_CONTROL_ACTION(2, action, true)
    eNative.PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, action, 1.0)
    Script.Yield(25)
    eNative.PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, action, 0.0)
end

function GTA.IsInSession()
    return eNative.NETWORK.NETWORK_IS_SESSION_STARTED() and eNative.NETWORK.NETWORK_IS_SESSION_ACTIVE()
end

function GTA.IsInSessionAlone()
    return eNative.PLAYER.GET_NUMBER_OF_PLAYERS() == 1
end

function GTA.EmptySession()
    FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.BailFromSession):OnClick()
end

function GTA.StartSession(sessionType)
    FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.SessionType):SetListIndex(sessionType)
    FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.StartSession):OnClick()
end

function GTA.IsScriptRunning(script)
    return eNative.SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(script.hash) > 0
end

function GTA.StartScript(script)
    if not eNative.SCRIPT.DOES_SCRIPT_EXIST(script.name) then
        return false
    end

    if GTA.IsScriptRunning(script) then
        return true
    end

    eNative.SCRIPT.REQUEST_SCRIPT(script.name)

    while not eNative.SCRIPT.HAS_SCRIPT_LOADED(script.name) do
        Script.Yield()
    end

    eNative.SYSTEM.START_NEW_SCRIPT(script.name, script.stack)
    eNative.SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED(script.name)

    return true
end

function GTA.ForceScriptHost(script)
    _ForceScriptHost(script)
    FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.ForceScriptHost):OnClick()
end

function GTA.TriggerTransaction(hash)
    if eNative.NETSHOPPING.NET_GAMESERVER_BASKET_IS_ACTIVE() then
        eNative.NETSHOPPING.NET_GAMESERVER_BASKET_END()
    end

    local price = eNative.NETSHOPPING.NET_GAMESERVER_GET_PRICE(hash, 0x57DE404E, true)
    local valid, id = GTA.BeginService(-1135378931, 0x57DE404E, hash, 0x562592BB, price, 2)

    if valid then
        GTA.CheckoutStart(id)
    end
end

--#endregion

--#region ImGui

function ImGui.BeginColumns(columns)
    if ImGui.BeginTable("main", columns, ImGuiTableFlags.SizingStretchSame) then
        ImGui.TableNextRow()
        ImGui.TableSetColumnIndex(0)

        return true
    end

    return false
end

function ImGui.EndColumns()
    ImGui.EndTable()
end

function ImGui.RedButtonStyle()
    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 255, 0, 0, 255)
end

function ImGui.ResetButtonStyle()
    ImGui.PopStyleColor()
end

--#endregion

--#region Heist Tool

--#region Generic

FeatureMgr.AddLoop(eFeature.Heist.Generic.Launch, nil, function(f)
    eFeature.Heist.Generic.Launch.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.Generic.Cutscene)

FeatureMgr.AddFeature(eFeature.Heist.Generic.Skip)

FeatureMgr.AddFeature(eFeature.Heist.Generic.Cut)

FeatureMgr.AddFeature(eFeature.Heist.Generic.Apply, function(f)
    local cut = FeatureMgr.GetFeature(eFeature.Heist.Generic.Cut):GetIntValue()
    eFeature.Heist.Generic.Apply.func(cut)
end)

--#endregion

--#region Agency

FeatureMgr.AddFeature(eFeature.Heist.Agency.Preps.Contract)

FeatureMgr.AddFeature(eFeature.Heist.Agency.Preps.Complete, function(f)
    local ftr      = eFeature.Heist.Agency.Preps.Contract
    local contract = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index
    eFeature.Heist.Agency.Preps.Complete.func(contract)
end)

FeatureMgr.AddFeature(eFeature.Heist.Agency.Misc.Finish)

FeatureMgr.AddFeature(eFeature.Heist.Agency.Misc.Cooldown)

FeatureMgr.AddFeature(eFeature.Heist.Agency.Payout.Select)

FeatureMgr.AddFeature(eFeature.Heist.Agency.Payout.Max, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.Agency.Payout.Select):SetIntValue(2500000)
    eFeature.Heist.Agency.Payout.Max.func()
end)

FeatureMgr.AddFeature(eFeature.Heist.Agency.Payout.Apply, function(f)
    local payout = FeatureMgr.GetFeature(eFeature.Heist.Agency.Payout.Select):GetIntValue()
    eFeature.Heist.Agency.Payout.Apply.func(payout)
end)

--#endregion

--#region Apartment

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Preps.Complete)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Preps.Reload)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Preps.Change)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.Force)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.Finish)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.FleecaHack)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.FleecaDrill)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.PacificHack)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.Cooldown)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.Play)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Misc.Unlock)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Cuts.Team, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Presets):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Receivers):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Double):SetVisible(false)
    FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Double):Toggle(false)

    local bool = f:GetListIndex() ~= 0
    FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Receivers):SetVisible((bool) and true or false)

    for i = 1, #apartmentPlayers do
        FeatureMgr.GetFeature(apartmentPlayers[i]):SetIntValue(0)
    end

    eFeature.Heist.Apartment.Cuts.Team.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Cuts.Receivers):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Cuts.Presets, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Double):Toggle(false)

    for i = 1, #apartmentPlayers do
        FeatureMgr.GetFeature(apartmentPlayers[i]):SetIntValue(0)
    end

    local ftr    = eFeature.Heist.Apartment.Cuts.Presets
    local preset = ftr.list[f:GetListIndex() + 1].index

    local list  = eFeature.Heist.Apartment.Cuts.Presets.list
    local index = list[f:GetListIndex() + 1].index
    SilentLogger.LogInfo(F("[Presets (Apartment)] Selected preset: %s. Don't forget to apply ツ", list:GetName(index)))

    if preset == -1 then
        FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Double):SetVisible(true)
        return
    else
        FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Double):SetVisible(false)
    end

    local ftr  = eFeature.Heist.Apartment.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    for i = 1, team do
        FeatureMgr.GetFeature(apartmentPlayers[i]):SetIntValue(preset)
    end
end)

FeatureMgr.AddLoop(eFeature.Heist.Apartment.Cuts.Bonus, nil, function(f)
    eFeature.Heist.Apartment.Cuts.Bonus.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Cuts.Double):SetVisible(false)

for i = 1, #apartmentPlayers do
    FeatureMgr.AddFeature(apartmentPlayers[i])
end

FeatureMgr.AddFeature(eFeature.Heist.Apartment.Cuts.Apply, function(f)
    local ftr  = eFeature.Heist.Apartment.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local ftr       = eFeature.Heist.Apartment.Cuts.Receivers
    local receivers = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local ftr    = eFeature.Heist.Apartment.Cuts.Presets
    local preset = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local cuts = {}

    for i = 1, #apartmentPlayers do
        I(cuts, FeatureMgr.GetFeature(apartmentPlayers[i]):GetIntValue())
    end

    eFeature.Heist.Apartment.Cuts.Apply.func(team, receivers, cuts)
end)

--#endregion

--#region Auto Shop

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Preps.Contract)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Preps.Complete, function(f)
    local ftr      = eFeature.Heist.AutoShop.Preps.Contract
    local contract = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index
    eFeature.Heist.AutoShop.Preps.Complete.func(contract)
end)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Preps.Reload)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Misc.Finish)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Misc.Cooldown)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Payout.Select)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Payout.Max, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.AutoShop.Payout.Select):SetIntValue(2000000)
end)

FeatureMgr.AddFeature(eFeature.Heist.AutoShop.Payout.Apply, function(f)
    local payout = FeatureMgr.GetFeature(eFeature.Heist.AutoShop.Payout.Select):GetIntValue()
    eFeature.Heist.AutoShop.Payout.Apply.func(payout)
end)

--#endregion

--#region Cayo Perico

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Difficulty)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Approach)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Loadout)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Primary)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Compound)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Compound)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Arts)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Island)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Island)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Advanced, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Default):SetVisible((f:IsToggled()) and true or false)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Cash):SetVisible((f:IsToggled()) and true or false)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Weed):SetVisible((f:IsToggled()) and true or false)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Coke):SetVisible((f:IsToggled()) and true or false)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Gold):SetVisible((f:IsToggled()) and true or false)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Arts):SetVisible((f:IsToggled()) and true or false)
    eFeature.Heist.CayoPerico.Preps.Advanced.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Default, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Cash):SetIntValue(eTable.Heist.CayoPerico.Values.Cash)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Weed):SetIntValue(eTable.Heist.CayoPerico.Values.Weed)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Coke):SetIntValue(eTable.Heist.CayoPerico.Values.Coke)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Gold):SetIntValue(eTable.Heist.CayoPerico.Values.Gold)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Arts):SetIntValue(eTable.Heist.CayoPerico.Values.Arts)
    eFeature.Heist.CayoPerico.Preps.Target.Value.Default.func()
end)
    :SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Cash):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Weed):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Coke):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Gold):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Arts):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Complete, function(f)
    local preps = {}

    for _, ftr in ipairs(cayoPreps) do
        local feature = FeatureMgr.GetFeature(ftr)

        if feature:GetType() == eFeatureType.Combo then
            I(preps, ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index)
        elseif feature:GetType() == eFeatureType.Toggle then
            I(preps, feature:IsToggled())
        elseif feature:GetType() == eFeatureType.InputInt then
            I(preps, feature:GetIntValue())
        end
    end

    eFeature.Heist.CayoPerico.Preps.Complete.func(U(preps))
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Reset)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Preps.Reload)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.Force)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.Finish)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.FingerprintHack)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.PlasmaCutterCut)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.DrainagePipeCut)

FeatureMgr.AddLoop(eFeature.Heist.CayoPerico.Misc.Bag, nil, function(f)
    eFeature.Heist.CayoPerico.Misc.Bag.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Solo)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Team)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Offline)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Online)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Cuts.Team, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Cuts.Presets):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Cuts.Crew):Toggle(false)

    for i = 1, #cayoPlayers do
        FeatureMgr.GetFeature(cayoPlayers[i]):SetIntValue(0)
    end

    eFeature.Heist.CayoPerico.Cuts.Team.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Cuts.Presets, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Cuts.Crew):Toggle(false)

    for i = 1, #cayoPlayers do
        FeatureMgr.GetFeature(cayoPlayers[i]):SetIntValue(0)
    end

    local ftr    = eFeature.Heist.CayoPerico.Cuts.Presets
    local preset = ftr.list[f:GetListIndex() + 1].index

    local list  = eFeature.Heist.CayoPerico.Cuts.Presets.list
    local index = list[f:GetListIndex() + 1].index
    SilentLogger.LogInfo(F("[Presets (Cayo Perico)] Selected preset: %s. Don't forget to apply ツ", list:GetName(index)))

    if preset == -1 then return end

    local ftr  = eFeature.Heist.CayoPerico.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    for i = 1, team do
        FeatureMgr.GetFeature(cayoPlayers[i]):SetIntValue(preset)
    end
end)

FeatureMgr.AddLoop(eFeature.Heist.CayoPerico.Cuts.Crew, nil, function(f)
    eFeature.Heist.CayoPerico.Cuts.Crew.func(f)
end)

for i = 1, #cayoPlayers do
    FeatureMgr.AddFeature(cayoPlayers[i])
end

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Cuts.Apply, function(f)
    local cuts = {}

    for i = 1, #cayoPlayers do
        I(cuts, FeatureMgr.GetFeature(cayoPlayers[i]):GetIntValue())
    end

    eFeature.Heist.CayoPerico.Cuts.Apply.func(cuts)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.File, function(f)
    local ftr  = eFeature.Heist.CayoPerico.Presets.File
    local file = ftr.list[f:GetListIndex() + 1].name
    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Presets.Name):SetStringValue(file)
    eFeature.Heist.CayoPerico.Presets.File.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.Load, function(f)
    local ftr  = eFeature.Heist.CayoPerico.Presets.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Heist.CayoPerico.Presets.Load.func(file)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.Remove, function(f)
    local ftr  = eFeature.Heist.CayoPerico.Presets.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Heist.CayoPerico.Presets.Remove.func(file)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.Refresh)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.Name)
    :SetStringValue(eFeature.Heist.CayoPerico.Presets.File.list[FeatureMgr.GetFeatureListIndex(eFeature.Heist.CayoPerico.Presets.File) + 1].name)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.Save, function(f)
    local file = FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Presets.Name):GetStringValue()

    if file == "" then
        SilentLogger.LogError("[Save (Cayo Perico)] Failed to save preset. File name is empty.")
        return
    end

    local preps = {
        difficulty      = FeatureMgr.GetFeatureListIndex(cayoPreps[1]),
        approach        = FeatureMgr.GetFeatureListIndex(cayoPreps[2]),
        loadout         = FeatureMgr.GetFeatureListIndex(cayoPreps[3]),
        primary_target  = FeatureMgr.GetFeatureListIndex(cayoPreps[4]),
        compound_target = FeatureMgr.GetFeatureListIndex(cayoPreps[5]),
        compound_amount = FeatureMgr.GetFeatureListIndex(cayoPreps[6]),
        arts_amount     = FeatureMgr.GetFeatureListIndex(cayoPreps[7]),
        island_target   = FeatureMgr.GetFeatureListIndex(cayoPreps[8]),
        island_amount   = FeatureMgr.GetFeatureListIndex(cayoPreps[9]),
        cash_value      = FeatureMgr.GetFeatureInt(cayoPreps[10]),
        weed_value      = FeatureMgr.GetFeatureInt(cayoPreps[11]),
        coke_value      = FeatureMgr.GetFeatureInt(cayoPreps[12]),
        gold_value      = FeatureMgr.GetFeatureInt(cayoPreps[13]),
        arts_value      = FeatureMgr.GetFeatureInt(cayoPreps[14]),
        advanced        = FeatureMgr.GetFeatureBool(eFeature.Heist.CayoPerico.Preps.Advanced)
    }

    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Presets.Name):SetStringValue("")
    eFeature.Heist.CayoPerico.Presets.Save.func(file, preps)
end)

FeatureMgr.AddFeature(eFeature.Heist.CayoPerico.Presets.Copy)

--#endregion

--#region Diamond Casino

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Difficulty)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Approach, function(f)
    local approach = f:GetListIndex() + 1

    local loadoutRanges = {
        [1] = { 1, 2 },
        [2] = { 3, 4 },
        [3] = { 5, 6 }
    }

    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Preps.Gunman):SetListIndex(0)

    local ftr = eFeature.Heist.DiamondCasino.Preps.Loadout
    FeatureMgr.GetFeature(ftr):SetList(ftr.list:GetNamesRange(U(loadoutRanges[approach])))
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Gunman, function(f)
    local approach = FeatureMgr.GetFeatureListIndex(eFeature.Heist.DiamondCasino.Preps.Approach) + 1
    local gunman   = eFeature.Heist.DiamondCasino.Preps.Gunman.list[f:GetListIndex() + 1].index

    local loadoutRanges = {
        [1] = {
            [1] = { 1, 2 },
            [2] = { 3, 4 },
            [3] = { 5, 6 }
        },

        [3] = {
            [1] = { 7,  8  },
            [2] = { 9,  10 },
            [3] = { 11, 12 }
        },

        [5] = {
            [1] = { 13, 14 },
            [2] = { 15, 16 },
            [3] = { 17, 18 }
        },

        [2] = {
            [1] = { 19, 20 },
            [2] = { 21, 22 },
            [3] = { 23, 24 }
        },

        [4] = {
            [1] = { 25, 26 },
            [2] = { 27, 28 },
            [3] = { 29, 30 }
        }
    }

    local ftr = eFeature.Heist.DiamondCasino.Preps.Loadout
    FeatureMgr.GetFeature(ftr):SetList(ftr.list:GetNamesRange(U(loadoutRanges[gunman][approach])))
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Loadout)
    :SetList(eFeature.Heist.DiamondCasino.Preps.Loadout.list:GetNamesRange(1, 2))

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Driver, function(f)
    local driver = eFeature.Heist.DiamondCasino.Preps.Driver.list[f:GetListIndex() + 1].index

    local vehicleRanges = {
        [1] = { 1,  4  },
        [4] = { 5,  8  },
        [2] = { 9,  12 },
        [3] = { 13, 16 },
        [5] = { 17, 20 },
    }

    local ftr = eFeature.Heist.DiamondCasino.Preps.Vehicles
    FeatureMgr.GetFeature(ftr):SetList(ftr.list:GetNamesRange(U(vehicleRanges[driver])))
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Vehicles)
    :SetList(eFeature.Heist.DiamondCasino.Preps.Vehicles.list:GetNamesRange(1, 4))

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Hacker)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Masks)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Keycards):SetListIndex(2)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Guards):SetListIndex(3)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Target)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Complete, function(f)
    local preps = {}

    for _, ftr in ipairs(diamondPreps) do
        I(preps, ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index)
    end

    I(preps, FeatureMgr.GetFeatureListIndex(eFeature.Heist.DiamondCasino.Preps.Loadout))
    I(preps, FeatureMgr.GetFeatureListIndex(eFeature.Heist.DiamondCasino.Preps.Vehicles))

    eFeature.Heist.DiamondCasino.Preps.Complete.func(U(preps))
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Reset)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Preps.Reload)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.Force)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.Finish)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.FingerprintHack)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.KeypadHack)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.VaultDoorDrill)

FeatureMgr.AddLoop(eFeature.Heist.DiamondCasino.Misc.Autograbber, nil, function(f)
    eFeature.Heist.DiamondCasino.Misc.Autograbber.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.Cooldown)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Misc.Setup)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Cuts.Team, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Cuts.Presets):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Cuts.Crew):Toggle(false)

    for i = 1, #diamondPlayers do
        FeatureMgr.GetFeature(diamondPlayers[i]):SetIntValue(0)
    end

    eFeature.Heist.DiamondCasino.Cuts.Team.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Cuts.Presets, function(f)
    for i = 1, #diamondPlayers do
        FeatureMgr.GetFeature(diamondPlayers[i]):SetIntValue(0)
    end

    local ftr    = eFeature.Heist.DiamondCasino.Cuts.Presets
    local preset = ftr.list[f:GetListIndex() + 1].index

    local list  = eFeature.Heist.DiamondCasino.Cuts.Presets.list
    local index = list[f:GetListIndex() + 1].index
    SilentLogger.LogInfo(F("[Presets (Cayo Perico)] Selected preset: %s. Don't forget to apply ツ", list:GetName(index)))

    if preset == -1 then
        return
    else
        FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Cuts.Crew):Toggle(false)
    end

    local ftr  = eFeature.Heist.DiamondCasino.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    for i = 1, team do
        FeatureMgr.GetFeature(diamondPlayers[i]):SetIntValue(preset)
    end
end)

FeatureMgr.AddLoop(eFeature.Heist.DiamondCasino.Cuts.Crew, nil, function(f)
    eFeature.Heist.DiamondCasino.Cuts.Crew.func(f)
end)

for i = 1, #diamondPlayers do
    FeatureMgr.AddFeature(diamondPlayers[i])
end

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Cuts.Apply, function(f)
    local cuts = {}

    for i = 1, #diamondPlayers do
        I(cuts, FeatureMgr.GetFeature(diamondPlayers[i]):GetIntValue())
    end

    eFeature.Heist.DiamondCasino.Cuts.Apply.func(cuts)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.File, function(f)
    local ftr  = eFeature.Heist.CayoPerico.Presets.File
    local file = ftr.list[f:GetListIndex() + 1].name
    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Presets.Name):SetStringValue(file)
    eFeature.Heist.DiamondCasino.Presets.File.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.Load, function(f)
    local ftr  = eFeature.Heist.DiamondCasino.Presets.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Heist.DiamondCasino.Presets.Load.func(file)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.Remove, function(f)
    local ftr  = eFeature.Heist.DiamondCasino.Presets.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Heist.DiamondCasino.Presets.Remove.func(file)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.Refresh)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.Name)
    :SetStringValue(eFeature.Heist.DiamondCasino.Presets.File.list[FeatureMgr.GetFeatureListIndex(eFeature.Heist.DiamondCasino.Presets.File) + 1].name)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.Save, function(f)
    local file = FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Presets.Name):GetStringValue()

    if file == "" then
        SilentLogger.LogError("[Save (Diamond Casino)] Failed to save preset. File name is empty.")
        return
    end

    local preps = {
        difficulty = FeatureMgr.GetFeatureListIndex(diamondPreps[1]),
        approach   = FeatureMgr.GetFeatureListIndex(diamondPreps[2]),
        gunman     = FeatureMgr.GetFeatureListIndex(diamondPreps[3]),
        driver     = FeatureMgr.GetFeatureListIndex(diamondPreps[4]),
        hacker     = FeatureMgr.GetFeatureListIndex(diamondPreps[5]),
        masks      = FeatureMgr.GetFeatureListIndex(diamondPreps[6]),
        guards     = FeatureMgr.GetFeatureListIndex(diamondPreps[7]),
        keycards   = FeatureMgr.GetFeatureListIndex(diamondPreps[8]),
        target     = FeatureMgr.GetFeatureListIndex(diamondPreps[9]),
        loadout    = FeatureMgr.GetFeatureListIndex(eFeature.Heist.DiamondCasino.Preps.Loadout),
        vehicles   = FeatureMgr.GetFeatureListIndex(eFeature.Heist.DiamondCasino.Preps.Vehicles)
    }

    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Presets.Name):SetStringValue("")
    eFeature.Heist.DiamondCasino.Presets.Save.func(file, preps)
end)

FeatureMgr.AddFeature(eFeature.Heist.DiamondCasino.Presets.Copy)

--#endregion

--#region Doomsday

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Preps.Act)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Preps.Complete, function(f)
    local ftr = eFeature.Heist.Doomsday.Preps.Act
    local act = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index
    eFeature.Heist.Doomsday.Preps.Complete.func(act)
end)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Preps.Reset)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Preps.Reload)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Misc.Force)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Misc.Finish)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Misc.DataHack)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Misc.DoomsdayHack)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Cuts.Team, function(f)
    FeatureMgr.GetFeature(eFeature.Heist.Doomsday.Cuts.Presets):SetListIndex(0)

    for i = 1, #doomsdayPlayers do
        FeatureMgr.GetFeature(doomsdayPlayers[i]):SetIntValue(0)
    end

    eFeature.Heist.Doomsday.Cuts.Team.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Cuts.Presets, function(f)
    for i = 1, #doomsdayPlayers do
        FeatureMgr.GetFeature(doomsdayPlayers[i]):SetIntValue(0)
    end

    local ftr    = eFeature.Heist.Doomsday.Cuts.Presets
    local preset = ftr.list[f:GetListIndex() + 1].index

    local list  = eFeature.Heist.Doomsday.Cuts.Presets.list
    local index = list[f:GetListIndex() + 1].index
    SilentLogger.LogInfo(F("[Presets (Cayo Perico)] Selected preset: %s. Don't forget to apply ツ", list:GetName(index)))

    if preset == -1 then return end

    local ftr  = eFeature.Heist.Doomsday.Cuts.Team
    local team = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    for i = 1, team do
        FeatureMgr.GetFeature(doomsdayPlayers[i]):SetIntValue(preset)
    end
end)

for i = 1, #doomsdayPlayers do
    FeatureMgr.AddFeature(doomsdayPlayers[i])
end

FeatureMgr.AddFeature(eFeature.Heist.Doomsday.Cuts.Apply, function(f)
    local cuts = {}

    for i = 1, #doomsdayPlayers do
        I(cuts, FeatureMgr.GetFeature(doomsdayPlayers[i]):GetIntValue())
    end

    eFeature.Heist.Doomsday.Cuts.Apply.func(cuts)
end)

--#endregion

--#region Salvage Yard

for i = 1, 3 do
    FeatureMgr.AddFeature(salvageSlotsRobbery[i])

    FeatureMgr.AddFeature(salvageSlotsVehicle[i])

    FeatureMgr.AddFeature(salvageSlotsMod[i])

    FeatureMgr.AddFeature(salvageSlotsKeep[i])

    FeatureMgr.AddFeature(salvageSlotsApply[i], function(f)
        local robbery = salvageSlotsRobbery[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsRobbery[i]) + 1].index
        local vehicle = salvageSlotsVehicle[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsVehicle[i]) + 1].index
        local mod     = salvageSlotsMod[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsMod[i]) + 1].index
        local keep    = salvageSlotsKeep[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsKeep[i]) + 1].index
        salvageSlotsApply[i].func(robbery, vehicle, mod, keep)
    end)
end

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Preps.Apply, function(f)
    local preps = {}

    for i = 1, 3 do
        local robbery = salvageSlotsRobbery[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsRobbery[i]) + 1].index
        local vehicle = salvageSlotsVehicle[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsVehicle[i]) + 1].index
        local mod     = salvageSlotsMod[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsMod[i]) + 1].index
        local keep    = salvageSlotsKeep[i].list[FeatureMgr.GetFeatureListIndex(salvageSlotsKeep[i]) + 1].index
        I(preps, robbery)
        I(preps, vehicle)
        I(preps, mod)
        I(preps, keep)
    end

    eFeature.Heist.SalvageYard.Preps.Apply.func(U(preps))
end)

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Preps.Complete)

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Preps.Reset)

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Preps.Reload)

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Misc.Cooldown.Kill)

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Misc.Cooldown.Skip)

for i = 1, #salvageSlotsAvailable do
    FeatureMgr.AddFeature(salvageSlotsAvailable[i])
end

FeatureMgr.AddLoop(eFeature.Heist.SalvageYard.Misc.Free.Setup, nil, function(f)
    eFeature.Heist.SalvageYard.Misc.Free.Setup.func(f)
end)

FeatureMgr.AddLoop(eFeature.Heist.SalvageYard.Misc.Free.Claim, nil, function(f)
    eFeature.Heist.SalvageYard.Misc.Free.Claim.func(f)
end)

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Payout.Salvage)

for i = 1, #salvageSlotsValue do
    FeatureMgr.AddFeature(salvageSlotsValue[i])
end

FeatureMgr.AddFeature(eFeature.Heist.SalvageYard.Payout.Apply, function(f)
    local salvageMultiplier = FeatureMgr.GetFeature(eFeature.Heist.SalvageYard.Payout.Salvage):GetFloatValue()
    local sellValues        = {}

    for i = 1, #salvageSlotsValue do
        I(sellValues, FeatureMgr.GetFeature(salvageSlotsValue[i]):GetIntValue())
    end

    eFeature.Heist.SalvageYard.Payout.Apply.func(salvageMultiplier, U(sellValues))
end)

--#endregion

--#endregion

--#region Business Tool

--#region Bunker

FeatureMgr.AddLoop(eFeature.Business.Bunker.Sale.Price, nil, function(f)
    eFeature.Business.Bunker.Sale.Price.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Sale.NoXp)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Sale.Sell, function(f)
    local bool = FeatureMgr.GetFeature(eFeature.Business.Bunker.Sale.NoXp):IsToggled()
    eFeature.Business.Bunker.Sale.Sell.func(bool)
end)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Misc.Open)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Misc.Supply)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Misc.Trigger)

FeatureMgr.AddLoop(eFeature.Business.Bunker.Misc.Supplier, nil, function(f)
    eFeature.Business.Bunker.Misc.Supplier.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Stats.SellMade)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Stats.SellUndertaken)

FeatureMgr.AddFeature(eFeature.Business.Bunker.Stats.Earnings)

for i = 1, #bunkerToggles do
    FeatureMgr.AddFeature(bunkerToggles[i])
end

FeatureMgr.AddFeature(eFeature.Business.Bunker.Stats.Apply, function(f)
    local params = {}

    for i = 1, #bunkerToggles do
        I(params, FeatureMgr.GetFeature(bunkerToggles[i]):IsToggled())
    end

    for i = 1, #bunkerStats do
        I(params, FeatureMgr.GetFeature(bunkerStats[i]):GetIntValue())
    end

    eFeature.Business.Bunker.Stats.Apply.func(U(params))
end)

--#endregion

--#region Hangar Cargo

FeatureMgr.AddLoop(eFeature.Business.Hangar.Sale.Price, nil, function(f)
    eFeature.Business.Hangar.Sale.Price.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Sale.NoXp)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Sale.Sell, function(f)
    local bool = FeatureMgr.GetFeature(eFeature.Business.Hangar.Sale.NoXp)
    eFeature.Business.Hangar.Sale.Sell.func(bool)
end)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Misc.Open)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Misc.Supply)

FeatureMgr.AddLoop(eFeature.Business.Hangar.Misc.Supplier, nil, function(f)
    eFeature.Business.Hangar.Misc.Supplier.func(f)
end)

FeatureMgr.AddLoop(eFeature.Business.Hangar.Misc.Cooldown, nil, function(f)
    eFeature.Business.Hangar.Misc.Cooldown.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Stats.BuyMade)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Stats.BuyUndertaken)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Stats.SellMade)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Stats.SellUndertaken)

FeatureMgr.AddFeature(eFeature.Business.Hangar.Stats.Earnings)

for i = 1, #hangarToggles do
    FeatureMgr.AddFeature(hangarToggles[i])
end

FeatureMgr.AddFeature(eFeature.Business.Hangar.Stats.Apply, function(f)
    local params = {}

    for i = 1, #hangarToggles do
        I(params, FeatureMgr.GetFeature(hangarToggles[i]):IsToggled())
    end

    for i = 1, #hangarStats do
        I(params, FeatureMgr.GetFeature(hangarStats[i]):GetIntValue())
    end

    eFeature.Business.Hangar.Stats.Apply.func(U(params))
end)

--#endregion

--#region Nightclub

FeatureMgr.AddLoop(eFeature.Business.Nightclub.Sale.Price, nil, function(f)
    eFeature.Business.Nightclub.Sale.Price.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Misc.Open)

FeatureMgr.AddLoop(eFeature.Business.Nightclub.Misc.Cooldown, nil, function(f)
    eFeature.Business.Nightclub.Misc.Cooldown.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Misc.Setup)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Stats.SellMade)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Stats.Earnings)

for i = 1, #nightclubToggles do
    FeatureMgr.AddFeature(nightclubToggles[i])
end

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Stats.Apply, function(f)
    local params = {}

    for i = 1, #nightclubToggles do
        I(params, FeatureMgr.GetFeature(nightclubToggles[i]):IsToggled())
    end

    for i = 1, #nightclubStats do
        I(params, FeatureMgr.GetFeature(nightclubStats[i]):GetIntValue())
    end

    eFeature.Business.Nightclub.Stats.Apply.func(U(params))
end)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Safe.Fill)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Safe.Collect)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Safe.Unbrick)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Popularity.Max)

FeatureMgr.AddFeature(eFeature.Business.Nightclub.Popularity.Min)

FeatureMgr.AddLoop(eFeature.Business.Nightclub.Popularity.Lock, nil, function(f)
    eFeature.Business.Nightclub.Popularity.Lock.func(f)
end)

--#endregion

--#region Special Cargo

FeatureMgr.AddLoop(eFeature.Business.CrateWarehouse.Sale.Price, nil, function(f)
    eFeature.Business.CrateWarehouse.Sale.Price.func(f)
end)

for i = 1, #specialSaleToggles do
    FeatureMgr.AddFeature(specialSaleToggles[i])
end

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Sale.Sell, function(f)
    local bools = {}

    for i = 1, #specialSaleToggles do
        I(bools, FeatureMgr.GetFeature(specialSaleToggles[i]))
    end

    eFeature.Business.CrateWarehouse.Sale.Sell.func(U(bools))
end)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Misc.Supply)

FeatureMgr.AddLoop(eFeature.Business.CrateWarehouse.Misc.Supplier, nil, function(f)
    eFeature.Business.CrateWarehouse.Misc.Supplier.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Misc.Select)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Misc.Max, function(f)
    FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Misc.Select):SetIntValue(111)
    eFeature.Business.CrateWarehouse.Misc.Max.func()
end)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Misc.Buy, function(f)
    local amount = FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Misc.Select):GetIntValue()
    eFeature.Business.CrateWarehouse.Misc.Buy.func(amount)
end)

FeatureMgr.AddLoop(eFeature.Business.CrateWarehouse.Misc.Cooldown, nil, function(f)
    eFeature.Business.CrateWarehouse.Misc.Cooldown.func(f)
end)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Stats.BuyMade)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Stats.BuyUndertaken)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Stats.SellMade)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Stats.SellUndertaken)

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Stats.Earnings)

for i = 1, #specialToggles do
    FeatureMgr.AddFeature(specialToggles[i])
end

FeatureMgr.AddFeature(eFeature.Business.CrateWarehouse.Stats.Apply, function(f)
    local params = {}

    for i = 1, #specialToggles do
        I(params, FeatureMgr.GetFeature(specialToggles[i]):IsToggled())
    end

    for i = 1, #specialStats do
        I(params, FeatureMgr.GetFeature(specialStats[i]):GetIntValue())
    end

    eFeature.Business.CrateWarehouse.Stats.Apply.func(U(params))
end)

--#endregion

--#region Misc

FeatureMgr.AddFeature(eFeature.Business.Misc.Supplies.Business)

FeatureMgr.AddFeature(eFeature.Business.Misc.Supplies.Resupply, function(f)
    local ftr      = eFeature.Business.Misc.Supplies.Business
    local business = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index
    eFeature.Business.Misc.Supplies.Resupply.func(business)
end)

--#endregion

--#endregion

--#region Money Tool

--#region Casino

FeatureMgr.AddFeature(eFeature.Money.Casino.LuckyWheel.Select)

FeatureMgr.AddFeature(eFeature.Money.Casino.LuckyWheel.Give, function(f)
    local ftr   = eFeature.Money.Casino.LuckyWheel.Select
    local prize = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index
    eFeature.Money.Casino.LuckyWheel.Give.func(prize)
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Slots.Win)

FeatureMgr.AddFeature(eFeature.Money.Casino.Slots.Lose)

FeatureMgr.AddFeature(eFeature.Money.Casino.Roulette.Land13)

FeatureMgr.AddFeature(eFeature.Money.Casino.Roulette.Land16)

FeatureMgr.AddFeature(eFeature.Money.Casino.Blackjack.Card)

FeatureMgr.AddFeature(eFeature.Money.Casino.Blackjack.Reveal, function(f)
    if GTA.IsScriptRunning(eScript.World.Casino.Blackjack) then
        if eLocal.World.Casino.Blackjack.CurrentTable:Get() ~= -1 then
            local dealersCard = eLocal.World.Casino.Blackjack.Dealer.FirstCard:Get()
            FeatureMgr.GetFeature(eFeature.Money.Casino.Blackjack.Card):SetStringValue(Helper.GetCardName(dealersCard))
        else
            FeatureMgr.GetFeature(eFeature.Money.Casino.Blackjack.Card):SetStringValue("Not at a table!")
        end
    else
        FeatureMgr.GetFeature(eFeature.Money.Casino.Blackjack.Card):SetStringValue("Not in Casino!")
    end
    eFeature.Money.Casino.Blackjack.Reveal.func()
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Blackjack.Trick, function(f)
    eFeature.Money.Casino.Blackjack.Trick.func()
    FeatureMgr.GetFeature(eFeature.Money.Casino.Blackjack.Reveal):OnClick()
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Poker.MyCards)

FeatureMgr.AddFeature(eFeature.Money.Casino.Poker.Cards)

FeatureMgr.AddFeature(eFeature.Money.Casino.Poker.Reveal, function(f)
    if GTA.IsScriptRunning(eScript.World.Casino.Poker) then
        if eLocal.World.Casino.Poker.CurrentTable:Get() ~= -1 then
            local myCards      = Helper.GetPokerCards(PLAYER_ID)
            local dealersCards = Helper.GetPokerCards(Helper.GetPokerPlayersCount() + 1)
            FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.MyCards):SetStringValue(myCards)
            FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.Cards):SetStringValue(dealersCards)
        else
            FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.MyCards):SetStringValue("Not at a table!")
            FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.Cards):SetStringValue("Not at a table!")
        end
    else
        FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.MyCards):SetStringValue("Not in Casino!")
        FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.Cards):SetStringValue("Not in Casino!")
    end
    eFeature.Money.Casino.Poker.Reveal.func()
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Poker.Give, function(f)
    eFeature.Money.Casino.Poker.Give.func()
    FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.Reveal):OnClick()
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Poker.Trick, function(f)
    eFeature.Money.Casino.Poker.Trick.func()
    FeatureMgr.GetFeature(eFeature.Money.Casino.Poker.Reveal):OnClick()
end)

FeatureMgr.AddLoop(eFeature.Money.Casino.Misc.Bypass, nil, function(f)
    eFeature.Money.Casino.Misc.Bypass.func(f)
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Misc.Limit.Select)

FeatureMgr.AddFeature(eFeature.Money.Casino.Misc.Limit.Acquire, function(f)
    local limit = FeatureMgr.GetFeature(eFeature.Money.Casino.Misc.Limit.Select):GetIntValue()
    eFeature.Money.Casino.Misc.Limit.Acquire.func(limit)
end)

FeatureMgr.AddFeature(eFeature.Money.Casino.Misc.Limit.Trade, function(f)
    local limit = FeatureMgr.GetFeature(eFeature.Money.Casino.Misc.Limit.Select):GetIntValue()
    eFeature.Money.Casino.Misc.Limit.Trade.func(limit)
end)

--#endregion

--#region Easy Money

FeatureMgr.AddFeature(eFeature.Money.EasyMoney.Instant.Give30m)

for i = 1, #easyLoops do
    FeatureMgr.AddLoop(easyLoops[i], function(f)
        local delay = FeatureMgr.GetFeature(settingsEasyDelays[i]):GetFloatValue()
        easyLoops[i].func(f, delay)
    end, function(f)
        local delay = FeatureMgr.GetFeature(settingsEasyDelays[i]):GetFloatValue()
        easyLoops[i].func(f, delay)
    end)
end

--#endregion

--#region Misc

FeatureMgr.AddFeature(eFeature.Money.Misc.Edit.Select)

FeatureMgr.AddFeature(eFeature.Money.Misc.Edit.Deposit, function(f)
    local amount = FeatureMgr.GetFeature(eFeature.Money.Misc.Edit.Select):GetIntValue()
    eFeature.Money.Misc.Edit.Deposit.func(amount)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Edit.Withdraw, function(f)
    local amount = FeatureMgr.GetFeature(eFeature.Money.Misc.Edit.Select):GetIntValue()
    eFeature.Money.Misc.Edit.Withdraw.func(amount)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Edit.Remove, function(f)
    local amount = FeatureMgr.GetFeature(eFeature.Money.Misc.Edit.Select):GetIntValue()
    eFeature.Money.Misc.Edit.Remove.func(amount)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Edit.DepositAll)

FeatureMgr.AddFeature(eFeature.Money.Misc.Edit.WithdrawAll)

FeatureMgr.AddFeature(eFeature.Money.Misc.Story.Select)

FeatureMgr.AddFeature(eFeature.Money.Misc.Story.Character, function(f)
    local charIndex = eFeature.Money.Misc.Story.Character.list[f:GetListIndex() + 1].index
    FeatureMgr.GetFeature(eFeature.Money.Misc.Story.Select):SetIntValue(eStat[F("SP%d_TOTAL_CASH", charIndex)]:Get())
    eFeature.Money.Misc.Story.Character.func(f)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Story.Apply, function(f)
    local ftr       = eFeature.Money.Misc.Story.Character
    local charIndex = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index
    local amount    = FeatureMgr.GetFeature(eFeature.Money.Misc.Story.Select):GetIntValue()
    eFeature.Money.Misc.Story.Apply.func(charIndex, amount)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Stats.Select)

FeatureMgr.AddFeature(eFeature.Money.Misc.Stats.Earned, function(f)
    local ftr        = eFeature.Money.Misc.Stats.Earned
    local earnedStat = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    FeatureMgr.GetFeature(eFeature.Money.Misc.Stats.Select):SetIntValue((earnedStat ~= 0) and earnedStat:Get() or 0)

    if f:GetListIndex() > 0 then
        FeatureMgr.GetFeature(eFeature.Money.Misc.Stats.Spent):SetListIndex(0)
    end

    eFeature.Money.Misc.Stats.Earned.func(f)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Stats.Spent, function(f)
    local ftr       = eFeature.Money.Misc.Stats.Spent
    local spentStat = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    FeatureMgr.GetFeature(eFeature.Money.Misc.Stats.Select):SetIntValue((spentStat ~= 0) and spentStat:Get() or 0)

    if f:GetListIndex() > 0 then
        FeatureMgr.GetFeature(eFeature.Money.Misc.Stats.Earned):SetListIndex(0)
    end

    eFeature.Money.Misc.Stats.Spent.func(f)
end)

FeatureMgr.AddFeature(eFeature.Money.Misc.Stats.Apply, function(f)
    local ftr        = eFeature.Money.Misc.Stats.Earned
    local earnedStat = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local ftr       = eFeature.Money.Misc.Stats.Spent
    local spentStat = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].index

    local amount = FeatureMgr.GetFeature(eFeature.Money.Misc.Stats.Select):GetIntValue()
    eFeature.Money.Misc.Stats.Apply.func(earnedStat, spentStat, amount)
end)

--#endregion

--#endregion

--#region Dev Tool

FeatureMgr.AddFeature(eFeature.Dev.Editor.Globals.Type, function(f)
    local examples = {
        [0] = { global = "262145 + 9415", value = "100" },
        [1] = { global = "262145 + 1",    value = "1.0" },
        [2] = { global = "262145 + 4413", value = "0"   }
    }

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Global)
        :SetName(examples[f:GetListIndex()].global)
        :SetStringValue("")

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value)
        :SetName(examples[f:GetListIndex()].value)
        :SetStringValue("")

    eFeature.Dev.Editor.Globals.Type.func(f)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Globals.Global)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Globals.Value)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Globals.Read, function(f)
    local globalString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Global):GetStringValue()

    if globalString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read global. Global is empty ツ")
        return
    end

    if not globalString:match("^[%d%s%+%-*/%%%(%)]+$") or globalString:match("%d+%s+%d+") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read global. Global is invalid ツ")
        return
    end

    local global = load(F("return %s", globalString))()

    if not global then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read global. Global is invalid ツ")
        return
    end

    local GetValue = {
        ["int"]   = ScriptGlobal.GetInt,
        ["float"] = ScriptGlobal.GetFloat,
        ["bool"]  = ScriptGlobal.GetBool
    }

    local ftr   = eFeature.Dev.Editor.Globals.Type
    local type  = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    local value = GetValue[type](global)

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue(S(value))
    eFeature.Dev.Editor.Globals.Read.func()
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Globals.Write, function(f)
    local globalString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Global):GetStringValue()

    if globalString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write global. Global is empty ツ")
        return
    end

    if not globalString:match("^[%d%s%+%-*/%%%(%)]+$") or globalString:match("%d+%s+%d+") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write global. Global is invalid ツ")
        return
    end

    local global = N(load(F("return %s", globalString))())

    if not global then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write global. Global is invalid ツ")
        return
    end

    local value = FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):GetStringValue()

    if type == "bool" then
        if value == "true" or value == "1" then
            value = 1
        elseif value == "false" or value == "0" then
            value = 0
        end
    end

    value = N(value)

    local GetValue = {
        ["int"]   = ScriptGlobal.GetInt,
        ["float"] = ScriptGlobal.GetFloat,
        ["bool"]  = ScriptGlobal.GetBool
    }

    local ftr  = eFeature.Dev.Editor.Globals.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    TEMP_GLOBAL = GetValue[type](global)
    eFeature.Dev.Editor.Globals.Write.func(type, global, value)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Globals.Revert, function(f)
    local globalString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Global):GetStringValue()

    if globalString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert global. Global is empty ツ")
        return
    end

    if not globalString:match("^[%d%s%+%-*/%%%(%)]+$") or globalString:match("%d+%s+%d+") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert global. Global is invalid ツ")
        return
    end

    local global = N(load(F("return %s", globalString))())

    if not global then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert global. Global is invalid ツ")
        return
    end

    if TEMP_GLOBAL ~= "TEMP" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Globals.Value):SetStringValue(S(TEMP_GLOBAL))
    end

    local ftr  = eFeature.Dev.Editor.Globals.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    eFeature.Dev.Editor.Globals.Revert.func(type, global)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Type, function(f)
    local examples = {
        [0] = { script = "am_mp_nightclub",            vLocal = "202 + 32 + 1", value = "0"    },
        [1] = { script = "fm_mission_controller_2020", vLocal = "31049 + 3",    value = "99.9" }
    }

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Script)
        :SetName(examples[f:GetListIndex()].script)
        :SetStringValue("")

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Local)
        :SetName(examples[f:GetListIndex()].vLocal)
        :SetStringValue("")

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value)
        :SetName(examples[f:GetListIndex()].value)
        :SetStringValue("")

    eFeature.Dev.Editor.Locals.Type.func(f)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Script)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Local)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Value)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Read, function(f)
    local scriptString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Script):GetStringValue()
    local localString  = FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Local):GetStringValue()

    if scriptString == "" or localString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read local. Script or local is empty ツ")
        return
    end

    if not scriptString:match("^[A-Za-z_]+$") or not localString:match("^[%d%s%+%-*/%%%(%)]+$") or localString:match("%d+%s+%d+") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read local. Script or local is invalid ツ")
        return
    end

    local vLocal = N(load(F("return %s", localString))())

    if not vLocal then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read local. Local is invalid ツ")
        return
    end

    local GetValue = {
        ["int"]   = ScriptLocal.GetInt,
        ["float"] = ScriptLocal.GetFloat
    }

    local ftr  = eFeature.Dev.Editor.Locals.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local value = GetValue[type](J(scriptString), vLocal)

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue(S(value))
    eFeature.Dev.Editor.Locals.Read.func()
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Write, function(f)
    local scriptString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Script):GetStringValue()
    local localString  = FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Local):GetStringValue()

    if scriptString == "" or localString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write local. Script or local is empty ツ")
        return
    end

    if not scriptString:match("^[%w%-]+$") or not localString:match("^[%d%s%+%-*/%%%(%)]+$") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write local. Script or local is invalid ツ")
        return
    end

    local vLocal = N(load(F("return %s", localString))())

    if not vLocal then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write local. Local is invalid ツ")
        return
    end

    local GetValue = {
        ["int"]   = ScriptLocal.GetInt,
        ["float"] = ScriptLocal.GetFloat
    }

    local ftr  = eFeature.Dev.Editor.Locals.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local value = N(FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):GetStringValue())

    TEMP_LOCAL = GetValue[type](J(script), vLocal)
    eFeature.Dev.Editor.Locals.Write.func(type, J(scriptString), vLocal, value)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Locals.Revert, function(f)
    local scriptString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Script):GetStringValue()
    local localString  = FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Local):GetStringValue()

    if scriptString == "" or localString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert local. Script or local is empty ツ")
        return
    end

    if not scriptString:match("^[%w%-]+$") or not localString:match("^[%d%s%+%-*/%%%(%)]+$") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert local. Script or local is invalid ツ")
        return
    end

    local vLocal = N(load(F("return %s", localString))())

    if not vLocal then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert local. Local is invalid ツ")
        return
    end

    local GetValue = {
        ["int"]   = ScriptLocal.GetInt,
        ["float"] = ScriptLocal.GetFloat
    }

    if TEMP_LOCAL ~= "TEMP" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Locals.Value):SetStringValue(S(TEMP_LOCAL))
    end

    local ftr  = eFeature.Dev.Editor.Locals.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    eFeature.Dev.Editor.Locals.Revert.func(type, J(scriptString), vLocal)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.From, function(f)
    for i = 1, #devStatsDefault do
        FeatureMgr.GetFeature(devStatsDefault[i]):SetVisible((not f:IsToggled()) and true or false)
    end
    for i = 1, #devStatsFromFile do
        FeatureMgr.GetFeature(devStatsFromFile[i]):SetVisible((f:IsToggled()) and true or false)
    end
    eFeature.Dev.Editor.Stats.From.func(f)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Type, function(f)
    local examples = {
        [0] = { stat = "MPX_KILLS",               value = "7777" },
        [1] = { stat = "MPX_PLAYER_MENTAL_STATE", value = "99.9" },
        [2] = { stat = "MPPLY_CHAR_IS_BADSPORT",  value = "1"    }
    }

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Stat)
        :SetName(examples[f:GetListIndex()].stat)
        :SetStringValue("")

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value)
        :SetName(examples[f:GetListIndex()].value)
        :SetStringValue("")

    eFeature.Dev.Editor.Stats.Type.func(f)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Stat)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Value)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Read, function(f)
    local statString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Stat):GetStringValue()

    if statString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue("")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read stat. Stat is empty ツ")
        return
    end

    local function IsStoryStat()
        return statString:find("SP0") or statString:find("SP1") or statString:find("SP2")
    end

    local hash = 0

    if statString:sub(1, 3) == "MPX" then
        statString = statString:gsub("MPX", F("MP%d", eStat.MPPLY_LAST_MP_CHAR:Get()))
        hash       = J(statString)
    elseif statString:find("MPPLY") or IsStoryStat() then
        hash = J(statString)
    else
        hash = J(statString)
    end

    local GetValue = {
        ["int"]   = Stats.GetInt,
        ["float"] = Stats.GetFloat,
        ["bool"]  = Stats.GetBool
    }

    local ftr  = eFeature.Dev.Editor.Stats.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local success, value = GetValue[type](hash)

    if not success then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read stat. Stat isn't found ツ")
        return
    end

    FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue(S(value))
    eFeature.Dev.Editor.Stats.Read.func()
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Write, function(f)
    local statString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Stat):GetStringValue()

    if statString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue("")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write stat. Stat is empty ツ")
        return
    end

    local function IsStoryStat()
        return statString:find("SP0") or statString:find("SP1") or statString:find("SP2")
    end

    local hash = 0

    if statString:sub(1, 3) == "MPX" then
        statString = statString:gsub("MPX", F("MP%d", eStat.MPPLY_LAST_MP_CHAR:Get()))
        hash       = J(statString)
    elseif statString:find("MPPLY") or IsStoryStat() then
        hash = J(statString)
    else
        hash = J(statString)
    end

    local GetValue = {
        ["int"]   = Stats.GetInt,
        ["float"] = Stats.GetFloat,
        ["bool"]  = Stats.GetBool
    }

    local ftr  = eFeature.Dev.Editor.Stats.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local value = FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):GetStringValue()

    if type == "bool" then
        if value == "true" or value == "1" then
            value = 1
        elseif value == "false" or value == "0" then
            value = 0
        end
    end

    value = N(value)

    local success, tempValue = GetValue[type](hash)

    if not success then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Write (Dev Tool)] Failed to write stat. Stat isn't found ツ")
        return
    end

    TEMP_STAT = tempValue
    eFeature.Dev.Editor.Stats.Write.func(type, hash, value)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Revert, function(f)
    local statString = FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Stat):GetStringValue()

    if statString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue("")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert stat. Stat is empty ツ")
        return
    end

    local function IsStoryStat()
        return statString:find("SP0") or statString:find("SP1") or statString:find("SP2")
    end

    local hash = 0

    if statString:sub(1, 3) == "MPX" then
        statString = statString:gsub("MPX", F("MP%d", eStat.MPPLY_LAST_MP_CHAR:Get()))
        hash       = J(statString)
    elseif statString:find("MPPLY") or IsStoryStat() then
        hash = J(statString)
    else
        hash = J(statString)
    end

    local GetValue = {
        ["int"]   = Stats.GetInt,
        ["float"] = Stats.GetFloat,
        ["bool"]  = Stats.GetBool
    }

    local ftr  = eFeature.Dev.Editor.Stats.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local success, value = GetValue[type](hash)

    if not success then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert stat. Stat isn't found ツ")
        return
    end

    if TEMP_STAT ~= "TEMP" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Value):SetStringValue(S(TEMP_STAT))
    end

    eFeature.Dev.Editor.Stats.Revert.func(type, hash)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.File):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.WriteAll, function(f)
    local ftr  = eFeature.Dev.Editor.Stats.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Dev.Editor.Stats.WriteAll.func(file)
end)
    :SetVisible(false)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Remove, function(f)
    local ftr  = eFeature.Dev.Editor.Stats.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Dev.Editor.Stats.Remove.func(file)
end)
    :SetVisible(false)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Refresh):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Copy):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Dev.Editor.Stats.Generate):SetVisible(false)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.Range, function(f)
    local examples = {
        [0] = { index = { "22050", "22050-22087" }, value = "5" },
        [1] = { index = { "27087", "27087-27092" }, value = "0" }
    }

    if f:IsToggled() then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Write)
            :SetName("Write Range")
            :SetDesc("Writes the selected value to the entered packed stats range.")

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Read):SetVisible(false)
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Revert):SetVisible(false)

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat)
            :SetName(examples[FeatureMgr.GetFeatureListIndex(eFeature.Dev.Editor.PackedStats.Type)].index[2])
            :SetDesc("Input your packed stats range here.")
            :SetStringValue("")

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value)
            :SetName("1")
            :SetStringValue("")
    else
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Write)
            :SetName("Write")
            :SetDesc("Writes the selected value to the entered packed stat.")

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Read):SetVisible(true)
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Revert):SetVisible(true)

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat)
            :SetName(examples[FeatureMgr.GetFeatureListIndex(eFeature.Dev.Editor.PackedStats.Type)].index[1])
            :SetDesc("Input your packed stat here.")
            :SetStringValue("")

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value)
            :SetName(examples[FeatureMgr.GetFeatureListIndex(eFeature.Dev.Editor.PackedStats.Type)].value)
            :SetStringValue("")
    end

    eFeature.Dev.Editor.PackedStats.Range.func(f)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.Type, function(f)
    local examples = {
        [0] = { index = { "22050", "22050-22087" }, value = "5" },
        [1] = { index = { "27087", "27087-27092" }, value = "0" }
    }

    if FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Range):IsToggled() then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat)
            :SetName(examples[f:GetListIndex()].index[2])
            :SetStringValue("")

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value)
            :SetName("1")
            :SetStringValue("")
    else
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat)
            :SetName(examples[f:GetListIndex()].index[1])
            :SetStringValue("")

        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value)
            :SetName(examples[f:GetListIndex()].value)
            :SetStringValue("")
    end

    eFeature.Dev.Editor.PackedStats.Type.func(f)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.PackedStat)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.Value)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.Read, function(f)
    local packedStatString = FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat):GetStringValue()

    if packedStatString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read packed stat. Packed stat is empty ツ")
        return
    end

    if not packedStatString:match("^%d+$") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Read (Dev Tool)] Failed to read packed stat. Packed stat is invalid ツ")
        return
    end

    local packedStat = N(packedStatString)

    local GetValue = {
        ["int"]  = eNative.STATS.GET_PACKED_STAT_INT_CODE,
        ["bool"] = eNative.STATS.GET_PACKED_STAT_BOOL_CODE
    }

    local ftr  = eFeature.Dev.Editor.PackedStats.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local value = GetValue[type](packedStat, eStat.MPPLY_LAST_MP_CHAR:Get())

    FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue(S(value))
    eFeature.Dev.Editor.PackedStats.Read.func()
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.Write, function(f)
    local firstPStat = nil
    local lastPStat  = nil

    if not FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Range):IsToggled() then
        local packedStatString = FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat):GetStringValue()

        if packedStatString == "" then
            FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("")
            SilentLogger.LogError("[Write (Dev Tool)] Failed to write packed stat. Packed stat is empty ツ")
            return
        end

        if not packedStatString:match("^%d+$") then
            FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("invalid")
            SilentLogger.LogError("[Write (Dev Tool)] Failed to write packed stat. Packed stat is invalid ツ")
            return
        end

        firstPStat = N(FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat):GetStringValue())
    else
        local packedStats = FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat):GetStringValue()

        if packedStats == "" then
            FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("")
            SilentLogger.LogError("[Write (Dev Tool)] Failed to write packed stats. Packed stats range is empty ツ")
            return
        end

        if not packedStats:match("^%d+%-%d+$") then
            FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("invalid")
            SilentLogger.LogError("[Write (Dev Tool)] Failed to write packed stats. Packed stats range is invalid ツ")
            return
        end

        firstPStat, lastPStat = packedStats:match("^(%d+)%-(%d+)$")
        firstPStat = N(firstPStat)
        lastPStat  = N(lastPStat)
    end

    local GetValue = {
        ["int"]  = eNative.STATS.GET_PACKED_STAT_INT_CODE,
        ["bool"] = eNative.STATS.GET_PACKED_STAT_BOOL_CODE
    }

    local ftr  = eFeature.Dev.Editor.PackedStats.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local value = FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):GetStringValue()

    if type == "bool" then
        if value == "true" or value == "1" then
            value = 1
        elseif value == "false" or value == "0" then
            value = 0
        end
    end

    value = N(value)

    TEMP_PSTAT = GetValue[type](firstPStat, eStat.MPPLY_LAST_MP_CHAR:Get())
    eFeature.Dev.Editor.PackedStats.Write.func(type, firstPStat, lastPStat, value)
end)

FeatureMgr.AddFeature(eFeature.Dev.Editor.PackedStats.Revert, function(f)
    local packedStatString = FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat):GetStringValue()

    if packedStatString == "" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert packed stat. Packed stat is empty ツ")
        return
    end

    if not packedStatString:match("^%d+$") then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue("invalid")
        SilentLogger.LogError("[Revert (Dev Tool)] Failed to revert packed stat. Packed stat is invalid ツ")
        return
    end

    local ftr  = eFeature.Dev.Editor.PackedStats.Type
    local type = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name

    local packedStat = N(FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.PackedStat):GetStringValue())

    if TEMP_PSTAT ~= "TEMP" then
        FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Value):SetStringValue(S(TEMP_PSTAT))
    end

    eFeature.Dev.Editor.PackedStats.Revert.func(type, packedStat)
end)

--#endregion

--#region Settings

methodKeys = {
    "agency",
    "apartment",
    "auto_shop",
    "cayo_perico",
    "diamond_casino",
    "doomsday"
}

delayKeys = {
    "_5k",
    "_50k",
    "_100k",
    "_180k",
    "_300k"
}

FeatureMgr.AddFeature(eFeature.Settings.Config.Open):Toggle(CONFIG.autoopen)

FeatureMgr.AddFeature(eFeature.Settings.Config.Logging):SetListIndex(CONFIG.logging)

FeatureMgr.AddFeature(eFeature.Settings.Config.Reset, function(f)
    eFeature.Settings.Config.Reset.func()

    FeatureMgr.GetFeature(eFeature.Settings.Config.Open):Toggle(CONFIG.autoopen)
    FeatureMgr.GetFeature(eFeature.Settings.Config.Logging):SetListIndex(CONFIG.logging)
    FeatureMgr.GetFeature(eFeature.Settings.Translation.File):SetListIndex(0)
    FeatureMgr.GetFeature(eFeature.Settings.Collab.JinxScript.Toggle):Toggle(CONFIG.collab.jinxscript.enabled)
    FeatureMgr.GetFeature(eFeature.Settings.Collab.JinxScript.Stop):Toggle(CONFIG.collab.jinxscript.autostop)
    FeatureMgr.GetFeature(eFeature.Settings.UnlockAllPoi.CayoPerico):Toggle(CONFIG.unlock_all_poi.cayo_perico)
    FeatureMgr.GetFeature(eFeature.Settings.UnlockAllPoi.DiamondCasino):Toggle(CONFIG.unlock_all_poi.diamond_casino)
    FeatureMgr.GetFeature(eFeature.Settings.EasyMoney.Prevention):Toggle(CONFIG.easy_money.dummy_prevention)

    for i = 1, #settingsInstantFinishes do
        FeatureMgr.GetFeature(settingsInstantFinishes[i]):SetListIndex(CONFIG.instant_finish[methodKeys[i]])
    end

    for i = 1, #settingsEasyDelays do
        FeatureMgr.GetFeature(settingsEasyDelays[i]):SetFloatValue((CONFIG.easy_money.delay[delayKeys[i]]))
    end

    FeatureMgr.GetFeature(eFeature.Settings.Translation.Load):OnClick()
end)

FeatureMgr.AddFeature(eFeature.Settings.Config.Copy)

FeatureMgr.AddFeature(eFeature.Settings.Config.Discord)

FeatureMgr.AddFeature(eFeature.Settings.Translation.File)

FeatureMgr.AddFeature(eFeature.Settings.Translation.Load, function(f)
    local ftr  = eFeature.Settings.Translation.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Settings.Translation.Load.func(file)
end)

FeatureMgr.AddFeature(eFeature.Settings.Translation.Remove, function(f)
    local ftr  = eFeature.Settings.Translation.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Settings.Translation.Remove.func(file)
end)

FeatureMgr.AddFeature(eFeature.Settings.Translation.Refresh)

FeatureMgr.AddFeature(eFeature.Settings.Translation.Export, function(f)
    local ftr  = eFeature.Settings.Translation.File
    local file = ftr.list[FeatureMgr.GetFeatureListIndex(ftr) + 1].name
    eFeature.Settings.Translation.Export.func(file)
end)

FeatureMgr.AddFeature(eFeature.Settings.Translation.Copy)

FeatureMgr.AddFeature(eFeature.Settings.Collab.JinxScript.Toggle):Toggle(CONFIG.collab.jinxscript.enabled)

FeatureMgr.AddFeature(eFeature.Settings.Collab.JinxScript.Discord)

FeatureMgr.AddFeature(eFeature.Settings.Collab.JinxScript.Stop):Toggle(CONFIG.collab.jinxscript.autostop)

for i = 1, #settingsInstantFinishes do
    FeatureMgr.AddFeature(settingsInstantFinishes[i]):SetListIndex(CONFIG.instant_finish[methodKeys[i]])
end

FeatureMgr.AddFeature(eFeature.Settings.UnlockAllPoi.CayoPerico, nil, function(f)
    eFeature.Settings.UnlockAllPoi.CayoPerico.func(f)
end)
    :Toggle(CONFIG.unlock_all_poi.cayo_perico)

FeatureMgr.AddFeature(eFeature.Settings.UnlockAllPoi.DiamondCasino, nil, function(f)
    eFeature.Settings.UnlockAllPoi.DiamondCasino.func(f)
end)
    :Toggle(CONFIG.unlock_all_poi.diamond_casino)

FeatureMgr.AddFeature(eFeature.Settings.EasyMoney.Prevention, nil, function(f)
    eFeature.Settings.EasyMoney.Prevention.func(f)
end)
    :Toggle(CONFIG.easy_money.dummy_prevention)

for i = 1, #settingsEasyDelays do
    FeatureMgr.AddFeature(settingsEasyDelays[i]):SetFloatValue((CONFIG.easy_money.delay[delayKeys[i]]))
end

--#endregion

--#region Script

function Script.LoadDefaultTranslation()
    local path = F("%s\\EN.json", TRANS_DIR)

    if FileMgr.DoesFileExist(path) then
        Script.Translate(path)
        SilentLogger.LogInfo(F("[Load (Settings)] Default translation should've been loaded ツ", file))
        return
    end

    SilentLogger.LogError("[Load (Settings)] Default translation doesn't exist ツ")
    SilentLogger.LogInfo("[Load (Settings)] Restart Silent Night to create default translation ツ")
end

function Script.LoadTranslation()
    local path = F("%s\\%s.json", TRANS_DIR, CONFIG.language)

    Helper.RefreshFiles()

    if FileMgr.DoesFileExist(path) then
        Script.Translate(path)

        local ftr = eFeature.Settings.Translation.File
        FeatureMgr.GetFeature(ftr):SetListIndex(ftr.list:GetIndex(CONFIG.language))
    else
        SilentLogger.LogError(F("[Load (Settings)] Translation «%s» doesn't exist ツ", CONFIG.language))
        Script.LoadDefaultTranslation()

        CONFIG.language = "EN"
        FeatureMgr.GetFeature(eFeature.Settings.Translation.File):SetListIndex(0)
        Json.EncodeToFile(CONFIG_PATH, CONFIG)
        CONFIG = Json.DecodeFromFile(CONFIG_PATH)
    end
end

function Script.LoadSubscribedScript(scriptName, stop)
    local ftr   = FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.SubscribedScripts)
    local list  = ftr:GetList()
    local found = false

    for i, name in ipairs(list) do
        if name == scriptName then
            ftr:SetListIndex(i - 1)
            found = true
            break
        end
    end

    if not found then
        SilentLogger.LogError(F("[%s (Settings)] Failed to find %s in subscribed scripts ツ", scriptName, scriptName))
        return
    end

    Script.Yield(1000)

    if not stop then
        FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.RunScript):OnClick()
    else
        FeatureMgr.GetFeatureByHash(eTable.Cherax.Features.StopScript):OnClick()
    end
end

function Script.OpenLuaTab()
    if CONFIG.autoopen then
        ClickGUI.SetActiveMenuTab(ClickTab.LuaTab)
    end
end

function Script.Translate(path)
    local translations = Json.DecodeFromFile(path)

    for hashStr, data in pairs(translations) do
        local hash    = N(hashStr)
        local feature = FeatureMgr.GetFeatureByHash(hash)

        if feature then
            if data.name then
                feature:SetName(data.name)
            end

            if data.desc then
                feature:SetDesc(data.desc)
            end

            if data.list and type(data.list) == "table" and feature.SetList then
                if feature:GetHash() ~= eTable.SilentNight.Features.Language then
                    feature:SetList(data.list)
                end
            end
        end
    end
end

function Script.ReAssign()
    PLAYER_ID = GTA.GetLocalPlayerId()

    if GTA_EDITION == "EE" then
        eGlobal.Business.Nightclub.Safe.Value  = { type = "int", global = 1845274 + 1 + (PLAYER_ID * 892) + 268 + 360 + 5            }
        eGlobal.Heist.Apartment.Cooldown       = { type = "int", global = 1877086 + 1 + (PLAYER_ID * 77) + 76                        }
        eGlobal.Heist.Apartment.Heist.Type     = { type = "int", global = 1877086 + (PLAYER_ID * 77) + 24 + 2                        }
        eLocal.World.Casino.Poker.CurrentTable = { type = "int", vLocal = 771 + 1 + (PLAYER_ID * 9) + 2, script = "three_card_poker" }
        eLocal.World.Casino.Blackjack          = {
            Dealer = {
                FirstCard  = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4) * 13) + 1,  script = "blackjack" },
                SecondCard = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4) * 13) + 2,  script = "blackjack" },
                ThirdCard  = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4) * 13) + 3,  script = "blackjack" }
            },

            CurrentTable = { type = "int", vLocal = 1798 + 1 + (PLAYER_ID * 8) + 4,                                                                 script = "blackjack" },
            VisibleCards = { type = "int", vLocal = 138 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1798 + 1 + (PLAYER_ID * 8) + 4) * 13) + 12, script = "blackjack" }
        }
    else
        eGlobal.Business.Nightclub.Safe.Value  = { type = "int", global = 1845225 + 1 + (PLAYER_ID * 889) + 268 + 360 + 5            }
        eGlobal.Heist.Apartment.Cooldown       = { type = "int", global = 1876941 + 1 + (PLAYER_ID * 77) + 76                        }
        eGlobal.Heist.Apartment.Heist.Type     = { type = "int", global = 1876941 + (PLAYER_ID * 77) + 24 + 2                        }
        eLocal.World.Casino.Poker.CurrentTable = { type = "int", vLocal = 769 + 1 + (PLAYER_ID * 9) + 2, script = "three_card_poker" }
        eLocal.World.Casino.Blackjack          = {
            Dealer = {
                FirstCard  = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4) * 13) + 1,  script = "blackjack" },
                SecondCard = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4) * 13) + 2,  script = "blackjack" },
                ThirdCard  = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4) * 13) + 3,  script = "blackjack" }
            },

            CurrentTable = { type = "int", vLocal = 1796 + 1 + (PLAYER_ID * 8) + 4,                                                                 script = "blackjack" },
            VisibleCards = { type = "int", vLocal = 136 + 846 + 1 + (ScriptLocal.GetInt(J("blackjack"), 1796 + 1 + (PLAYER_ID * 8) + 4) * 13) + 12, script = "blackjack" }
        }
    end
end

function Script.ReloadFeatures()
    FeatureMgr.GetFeature(eFeature.Heist.SalvageYard.Payout.Salvage)
        :SetFloatValue(eGlobal.Heist.SalvageYard.Vehicle.SalvageValueMultiplier:Get())

    FeatureMgr.GetFeature(eFeature.Heist.SalvageYard.Payout.Slot1)
        :SetIntValue(eGlobal.Heist.SalvageYard.Vehicle.Slot1.Value:Get())

    FeatureMgr.GetFeature(eFeature.Heist.SalvageYard.Payout.Slot2)
        :SetIntValue(eGlobal.Heist.SalvageYard.Vehicle.Slot2.Value:Get())

    FeatureMgr.GetFeature(eFeature.Heist.SalvageYard.Payout.Slot3)
        :SetIntValue(eGlobal.Heist.SalvageYard.Vehicle.Slot3.Value:Get())

    FeatureMgr.GetFeature(eFeature.Business.Bunker.Stats.SellMade)
        :SetIntValue(eStat.MPX_LIFETIME_BKR_SEL_COMPLETBC5:Get())

    FeatureMgr.GetFeature(eFeature.Business.Bunker.Stats.SellUndertaken)
        :SetIntValue(eStat.MPX_LIFETIME_BKR_SEL_UNDERTABC5:Get())

    FeatureMgr.GetFeature(eFeature.Business.Bunker.Stats.Earnings)
        :SetIntValue(eStat.MPX_LIFETIME_BKR_SELL_EARNINGS5:Get())

    FeatureMgr.GetFeature(eFeature.Business.Hangar.Stats.BuyMade)
        :SetIntValue(eStat.MPX_LFETIME_HANGAR_BUY_COMPLET:Get())

    FeatureMgr.GetFeature(eFeature.Business.Hangar.Stats.BuyUndertaken)
        :SetIntValue(eStat.MPX_LFETIME_HANGAR_BUY_UNDETAK:Get())

    FeatureMgr.GetFeature(eFeature.Business.Hangar.Stats.SellMade)
        :SetIntValue(eStat.MPX_LFETIME_HANGAR_SEL_COMPLET:Get())

    FeatureMgr.GetFeature(eFeature.Business.Hangar.Stats.SellUndertaken)
        :SetIntValue(eStat.MPX_LFETIME_HANGAR_SEL_UNDETAK:Get())

    FeatureMgr.GetFeature(eFeature.Business.Hangar.Stats.Earnings)
        :SetIntValue(eStat.MPX_LFETIME_HANGAR_EARNINGS:Get())

    FeatureMgr.GetFeature(eFeature.Business.Nightclub.Stats.SellMade)
        :SetIntValue(eStat.MPX_HUB_SALES_COMPLETED:Get())

    FeatureMgr.GetFeature(eFeature.Business.Nightclub.Stats.Earnings)
        :SetIntValue(eStat.MPX_HUB_EARNINGS:Get())

    FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Stats.BuyMade)
        :SetIntValue(eStat.MPX_LIFETIME_BUY_COMPLETE:Get())

    FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Stats.BuyUndertaken)
        :SetIntValue(eStat.MPX_LIFETIME_BUY_UNDERTAKEN:Get())

    FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Stats.SellMade)
        :SetIntValue(eStat.MPX_LIFETIME_SELL_COMPLETE:Get())

    FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Stats.SellUndertaken)
        :SetIntValue(eStat.MPX_LIFETIME_SELL_UNDERTAKEN:Get())

    FeatureMgr.GetFeature(eFeature.Business.CrateWarehouse.Stats.Earnings)
        :SetIntValue(eStat.MPX_LIFETIME_CONTRA_EARNINGS:Get())

    FeatureMgr.GetFeature(eFeature.Business.Misc.Supplies.Business)
        :SetList(eFeature.Business.Misc.Supplies.Business.list:GetNames())
end

HAS_PARSED         = false
LAST_SESSION_STATE = false

function Script.ReParse()
    if not GTA.IsInSession() then
        if HAS_PARSED then
            HAS_PARSED = false
        end

        Script.Yield(5000)
    else
        if not HAS_PARSED or LAST_SESSION_STATE ~= GTA.IsInSession() then
            Script.Yield(5000)
            Parser.ParseTunables(eTunable)
            Parser.ParseStats(eStat)
            Utils.FillDynamicTables()
            Parser.ParseTables(eTable)
            Script.ReAssign()
            Parser.ParseGlobals(eGlobal)
            Script.ReloadFeatures()
            Parser.ParseLocals(eLocal)
            Parser.ParsePackedBools(ePackedBool)

            while not (
                eTunable.HAS_PARSED
                and eGlobal.HAS_PARSED
                and eLocal.HAS_PARSED
                and eStat.HAS_PARSED
                and ePackedBool.HAS_PARSED
                and eTable.HAS_PARSED
            ) do
                Script.Yield()
            end

            HAS_PARSED = true
        end
    end

    LAST_SESSION_STATE = GTA.IsInSession()
end

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    Script.ReParse()
    Script.Yield()
end)

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    local heist = eGlobal.Heist.Apartment.Heist.Type:Get()

    if heist ~= eTable.Heist.Apartment.Heists.PacificJob then
        FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Bonus):SetVisible(false)
    else
        FeatureMgr.GetFeature(eFeature.Heist.Apartment.Cuts.Bonus):SetVisible(true)
    end

    Script.Yield()
end)

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    local ftr = eFeature.Heist.Apartment.Cuts.Presets

    if FeatureMgr.GetFeatureListIndex(ftr) ~= 3 then
        Script.Yield()
        return
    end

    local ftr = eFeature.Heist.Apartment.Cuts.Double
    eFeature.Heist.Apartment.Cuts.Presets.func(FeatureMgr.GetFeature(ftr):IsToggled())
    Script.Yield()
end)

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    local ftr = eFeature.Heist.CayoPerico.Cuts.Presets

    if FeatureMgr.GetFeatureListIndex(ftr) ~= 3 then
        Script.Yield()
        return
    end

    FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Cuts.Crew):Toggle(false)
    eFeature.Heist.CayoPerico.Cuts.Presets.func()
    Script.Yield()
end)

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    local ftr = eFeature.Heist.DiamondCasino.Cuts.Presets

    if FeatureMgr.GetFeatureListIndex(ftr) ~= 3 then
        Script.Yield()
        return
    end

    FeatureMgr.GetFeature(eFeature.Heist.DiamondCasino.Cuts.Crew):Toggle(true)
    eFeature.Heist.DiamondCasino.Cuts.Presets.func()
    Script.Yield()
end)

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    local ftr = eFeature.Heist.Doomsday.Cuts.Presets

    if FeatureMgr.GetFeatureListIndex(ftr) ~= 3 then
        Script.Yield()
        return
    end

    eFeature.Heist.Doomsday.Cuts.Presets.func()
    Script.Yield()
end)

STATES = { false, false, false, false, false }

Script.RegisterLooped(function()
    if ShouldUnload() then return end

    if not CONFIG.easy_money.dummy_prevention then
        Script.Yield()
        return
    end

    local toggled = nil

    for i, ftr in ipairs(easyLoops) do
        local isOn = FeatureMgr.GetFeature(ftr):IsToggled()

        if isOn and not STATES[i] then
            toggled = i
        end

        STATES[i] = isOn
    end

    if toggled then
        for i, ftr in ipairs(easyLoops) do
            FeatureMgr.GetFeature(ftr):Toggle(i == toggled)
        end
    end

    Script.Yield()
end)

FileMgr.ExportTranslation("EN")

Script.LoadTranslation()

Script.OpenLuaTab()

--#endregion Script

--#region Renderer

Renderer = {}

function Renderer.RenderHeistTool()
    if ImGui.BeginTabItem("Heist Tool") then
        if ImGui.BeginTabBar("Heist Tabs") then
            if ImGui.BeginTabItem("Agency") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Preps.Contract)
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Preps.Complete)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Misc.Finish)
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Misc.Cooldown)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Payout") then
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Payout.Select)
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Payout.Max)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.Agency.Payout.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Apartment") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Preps.Complete)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Preps.Reload)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Preps.Change)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Launch)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.Force)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.Finish)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.FleecaHack)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.FleecaDrill)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.PacificHack)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.Cooldown)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.Play)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Misc.Unlock)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Cuts") then
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Team)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Receivers)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Presets)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Bonus)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Double)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Player1)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Player2)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Player3)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Player4)
                        ClickGUI.RenderFeature(eFeature.Heist.Apartment.Cuts.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Auto Shop") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Preps.Contract)
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Preps.Complete)
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Preps.Reload)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Misc.Finish)
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Misc.Cooldown)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Payout") then
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Payout.Select)
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Payout.Max)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.AutoShop.Payout.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Cayo Perico") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Difficulty)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Approach)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Loadout)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Primary)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Compound)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Compound)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Arts)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Island)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Island)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Advanced)

                        if FeatureMgr.GetFeature(eFeature.Heist.CayoPerico.Preps.Advanced):IsToggled() then
                            ImGui.SameLine()
                        end

                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Default)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Cash)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Weed)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Coke)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Gold)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Arts)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Complete)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Reset)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Preps.Reload)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Presets") then
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.File)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.Load)
                        ImGui.SameLine()
                        ImGui.RedButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.Remove)
                        ImGui.ResetButtonStyle()
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.Refresh)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.Name)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.Save)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Presets.Copy)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Force)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Finish)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.FingerprintHack)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.PlasmaCutterCut)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.DrainagePipeCut)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Bag)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Solo)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Team)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Offline)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Online)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Cuts") then
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Team)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Presets)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Crew)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Player1)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Player2)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Player3)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Player4)
                        ClickGUI.RenderFeature(eFeature.Heist.CayoPerico.Cuts.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Non-Host") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cut)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Diamond Casino") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Difficulty)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Approach)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Gunman)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Loadout)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Driver)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Vehicles)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Hacker)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Masks)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Keycards)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Guards)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Target)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Complete)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Reset)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Preps.Reload)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Presets") then
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.File)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.Load)
                        ImGui.SameLine()
                        ImGui.RedButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.Remove)
                        ImGui.ResetButtonStyle()
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.Refresh)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.Name)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.Save)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Presets.Copy)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Launch)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.Force)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.Finish)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.FingerprintHack)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.KeypadHack)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.VaultDoorDrill)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.Autograbber)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.Cooldown)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Misc.Setup)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Cuts") then
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Team)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Presets)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Crew)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Player1)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Player2)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Player3)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Player4)
                        ClickGUI.RenderFeature(eFeature.Heist.DiamondCasino.Cuts.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Non-Host") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cut)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Doomsday") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Preps.Act)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Preps.Complete)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Preps.Reset)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Preps.Reload)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Launch)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Misc.Force)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Misc.Finish)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Misc.DataHack)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Misc.DoomsdayHack)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Cuts") then
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Team)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Presets)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Player1)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Player2)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Player3)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Player4)
                        ClickGUI.RenderFeature(eFeature.Heist.Doomsday.Cuts.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Non-Host") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cut)
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Salvage Yard") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Slot 1") then
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot1.Robbery)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot1.Vehicle)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot1.Modification)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot1.Keep)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot1.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Preps") then
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Preps.Apply)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Preps.Complete)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Preps.Reset)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Preps.Reload)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Slot 2") then
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot2.Robbery)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot2.Vehicle)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot2.Modification)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot2.Keep)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot2.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Heist.Generic.Cutscene)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Cooldown.Kill)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Cooldown.Skip)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Availability.Slot1)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Availability.Slot2)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Availability.Slot3)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Free.Setup)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Misc.Free.Claim)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Slot 3") then
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot3.Robbery)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot3.Vehicle)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot3.Modification)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot3.Keep)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Slot3.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Payout") then
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Payout.Salvage)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Payout.Slot1)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Payout.Slot2)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Payout.Slot3)
                        ClickGUI.RenderFeature(eFeature.Heist.SalvageYard.Payout.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end
            ImGui.EndTabBar()
        end
        ImGui.EndTabItem()
    end
end

function Renderer.RenderBusinessTool()
    if ImGui.BeginTabItem("Business Tool") then
        if ImGui.BeginTabBar("Business Tabs") then
            if ImGui.BeginTabItem("Bunker") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Sale") then
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Sale.Price)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Sale.NoXp)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Sale.Sell)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Misc.Open)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Misc.Supply)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Misc.Trigger)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Misc.Supplier)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Stats") then
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Stats.SellMade)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Stats.SellUndertaken)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Stats.Earnings)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Stats.NoSell)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Stats.NoEarnings)
                        ClickGUI.RenderFeature(eFeature.Business.Bunker.Stats.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Hangar Cargo") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Sale") then
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Sale.Price)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Sale.NoXp)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Sale.Sell)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Misc.Open)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Misc.Supply)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Misc.Supplier)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Misc.Cooldown)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Stats") then
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.BuyMade)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.BuyUndertaken)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.SellMade)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.SellUndertaken)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.Earnings)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.NoBuy)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.NoSell)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.NoEarnings)
                        ClickGUI.RenderFeature(eFeature.Business.Hangar.Stats.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Nightclub") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Sale") then
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Sale.Price)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Safe") then
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Safe.Fill)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Safe.Collect)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Safe.Unbrick)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Misc.Open)
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Misc.Cooldown)
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Misc.Setup)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Popularity") then
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Popularity.Lock)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Popularity.Max)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Popularity.Min)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Stats") then
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Stats.SellMade)
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Stats.Earnings)
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Stats.NoSell)
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Stats.NoEarnings)
                        ClickGUI.RenderFeature(eFeature.Business.Nightclub.Stats.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Special Cargo") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Sale") then
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Sale.Price)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Sale.NoXp)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Sale.NoCrateback)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Sale.Sell)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Misc.Supply)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Misc.Select)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Misc.Max)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Misc.Buy)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Misc.Supplier)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Misc.Cooldown)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Stats") then
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.BuyMade)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.BuyUndertaken)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.SellMade)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.SellUndertaken)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.Earnings)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.NoBuy)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.NoSell)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.NoEarnings)
                        ClickGUI.RenderFeature(eFeature.Business.CrateWarehouse.Stats.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Misc") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Supplies") then
                        ClickGUI.RenderFeature(eFeature.Business.Misc.Supplies.Business)
                        ClickGUI.RenderFeature(eFeature.Business.Misc.Supplies.Resupply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end
            ImGui.EndTabBar()
        end
        ImGui.EndTabItem()
    end
end

function Renderer.RenderMoneyTool()
    if ImGui.BeginTabItem("Money Tool") then
        if ImGui.BeginTabBar("Money Tabs") then
            if ImGui.BeginTabItem("Casino") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Lucky Wheel") then
                        ClickGUI.RenderFeature(eFeature.Money.Casino.LuckyWheel.Select)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.LuckyWheel.Give)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Blackjack") then
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Blackjack.Card)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Blackjack.Reveal)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Blackjack.Trick)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Slot Machines") then
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Slots.Win)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Slots.Lose)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Poker") then
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Poker.MyCards)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Poker.Cards)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Poker.Reveal)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Poker.Give)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Poker.Trick)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Roulette") then
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Roulette.Land13)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Roulette.Land16)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Misc") then
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Misc.Bypass)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Misc.Limit.Select)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Misc.Limit.Acquire)
                        ClickGUI.RenderFeature(eFeature.Money.Casino.Misc.Limit.Trade)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Easy Money") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Instant") then
                        ClickGUI.RenderFeature(eFeature.Money.EasyMoney.Instant.Give30m)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Freeroam") then
                        ClickGUI.RenderFeature(eFeature.Money.EasyMoney.Freeroam._5k)
                        ClickGUI.RenderFeature(eFeature.Money.EasyMoney.Freeroam._50k)
                        ClickGUI.RenderFeature(eFeature.Money.EasyMoney.Freeroam._100k)
                        ClickGUI.RenderFeature(eFeature.Money.EasyMoney.Freeroam._180k)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Property") then
                        ClickGUI.RenderFeature(eFeature.Money.EasyMoney.Property._300k)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end

            if ImGui.BeginTabItem("Misc") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Edit") then
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Edit.Select)
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Edit.Deposit)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Edit.Withdraw)
                        ImGui.RedButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Edit.Remove)
                        ImGui.ResetButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Edit.DepositAll)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Edit.WithdrawAll)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Story") then
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Story.Select)
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Story.Character)
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Story.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Stats") then
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Stats.Select)
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Stats.Earned)
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Stats.Spent)
                        ClickGUI.RenderFeature(eFeature.Money.Misc.Stats.Apply)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end
            ImGui.EndTabBar()
        end
        ImGui.EndTabItem()
    end
end

function Renderer.RenderDevTool()
    if ImGui.BeginTabItem("Dev Tool") then
        if ImGui.BeginTabBar("Dev Tabs") then
            if ImGui.BeginTabItem("Editor") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Globals") then
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Globals.Type)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Globals.Global)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Globals.Value)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Globals.Read)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Globals.Write)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Globals.Revert)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Packed Stats") then
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.Range)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.Type)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.PackedStat)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.Value)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.Read)

                        if FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Read):IsVisible() then
                            ImGui.SameLine()
                        end

                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.Write)

                        if FeatureMgr.GetFeature(eFeature.Dev.Editor.PackedStats.Write):GetName() == "Write" then
                            ImGui.SameLine()
                        end

                        ClickGUI.RenderFeature(eFeature.Dev.Editor.PackedStats.Revert)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Locals") then
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Type)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Script)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Local)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Value)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Read)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Write)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Locals.Revert)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Stats") then
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.From)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Type)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Stat)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Value)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Read)

                        if FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Read):IsVisible() then
                            ImGui.SameLine()
                        end

                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Write)

                        if FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Write):IsVisible() then
                            ImGui.SameLine()
                        end

                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Revert)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.File)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.WriteAll)

                        if FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.WriteAll):IsVisible() then
                            ImGui.SameLine()
                        end

                        ImGui.RedButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Remove)
                        ImGui.ResetButtonStyle()

                        if FeatureMgr.GetFeature(eFeature.Dev.Editor.Stats.Remove):IsVisible() then
                            ImGui.SameLine()
                        end

                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Refresh)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Copy)
                        ClickGUI.RenderFeature(eFeature.Dev.Editor.Stats.Generate)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end
            ImGui.EndTabBar()
        end
        ImGui.EndTabItem()
    end
end

function Renderer.RenderSettings()
    if ImGui.BeginTabItem("Settings") then
        if ImGui.BeginTabBar("Settings Tabs") then
            if ImGui.BeginTabItem("Configuration") then
                if ImGui.BeginColumns(3) then
                    if ClickGUI.BeginCustomChildWindow("Config & Discord") then
                        ClickGUI.RenderFeature(eFeature.Settings.Config.Open)
                        ClickGUI.RenderFeature(eFeature.Settings.Config.Logging)
                        ImGui.RedButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Settings.Config.Reset)
                        ImGui.ResetButtonStyle()
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Settings.Config.Copy)
                        ClickGUI.RenderFeature(eFeature.Settings.Config.Discord)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Translation") then
                        ClickGUI.RenderFeature(eFeature.Settings.Translation.File)
                        ClickGUI.RenderFeature(eFeature.Settings.Translation.Load)
                        ImGui.SameLine()
                        ImGui.RedButtonStyle()
                        ClickGUI.RenderFeature(eFeature.Settings.Translation.Remove)
                        ImGui.ResetButtonStyle()
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Settings.Translation.Refresh)
                        ClickGUI.RenderFeature(eFeature.Settings.Translation.Export)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Settings.Translation.Copy)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Collabs") then
                        ClickGUI.RenderFeature(eFeature.Settings.Collab.JinxScript.Toggle)
                        ImGui.SameLine()
                        ClickGUI.RenderFeature(eFeature.Settings.Collab.JinxScript.Discord)
                        ClickGUI.RenderFeature(eFeature.Settings.Collab.JinxScript.Stop)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Instant Finish") then
                        ClickGUI.RenderFeature(eFeature.Settings.InstantFinish.Agency)
                        ClickGUI.RenderFeature(eFeature.Settings.InstantFinish.Apartment)
                        ClickGUI.RenderFeature(eFeature.Settings.InstantFinish.AutoShop)
                        ClickGUI.RenderFeature(eFeature.Settings.InstantFinish.CayoPerico)
                        ClickGUI.RenderFeature(eFeature.Settings.InstantFinish.DiamondCasino)
                        ClickGUI.RenderFeature(eFeature.Settings.InstantFinish.Doomsday)
                        ClickGUI.EndCustomChildWindow()
                    end

                    if ClickGUI.BeginCustomChildWindow("Unlock All POI") then
                        ClickGUI.RenderFeature(eFeature.Settings.UnlockAllPoi.CayoPerico)
                        ClickGUI.RenderFeature(eFeature.Settings.UnlockAllPoi.DiamondCasino)
                        ClickGUI.EndCustomChildWindow()
                    end

                    ImGui.TableNextColumn()

                    if ClickGUI.BeginCustomChildWindow("Easy Money") then
                        ClickGUI.RenderFeature(eFeature.Settings.EasyMoney.Prevention)
                        ClickGUI.RenderFeature(eFeature.Settings.EasyMoney.Delay._5k)
                        ClickGUI.RenderFeature(eFeature.Settings.EasyMoney.Delay._50k)
                        ClickGUI.RenderFeature(eFeature.Settings.EasyMoney.Delay._100k)
                        ClickGUI.RenderFeature(eFeature.Settings.EasyMoney.Delay._180k)
                        ClickGUI.RenderFeature(eFeature.Settings.EasyMoney.Delay._300k)
                        ClickGUI.EndCustomChildWindow()
                    end
                    ImGui.EndColumns()
                end
                ImGui.EndTabItem()
            end
            ImGui.EndTabBar()
        end
        ImGui.EndTabItem()
    end
end

function Renderer.RenderClickGUI()
    if ImGui.BeginTabBar(SCRIPT_NAME) then
        Renderer.RenderHeistTool()
        Renderer.RenderBusinessTool()
        Renderer.RenderMoneyTool()
        Renderer.RenderDevTool()
        Renderer.RenderSettings()
        ImGui.EndTabBar()
    end
end

ClickGUI.AddTab(F("%s v%s %s", SCRIPT_NAME, SCRIPT_VER, GTA_EDITION), Renderer.RenderClickGUI)

function Renderer.RenderListGUI()
    local root = ListGUI.GetRootTab()
    if not root then return end

    local SilentNightTab = root:AddSubTab(F("%s v%s %s", SCRIPT_NAME, SCRIPT_VER, GTA_EDITION), SCRIPT_NAME)

    local HeistToolTab = SilentNightTab:AddSubTab("Heist Tool", "Heist Tool")
    if HeistToolTab then
        local AgencyTab = HeistToolTab:AddSubTab("Agency", "Agency")
        if AgencyTab then
            local prepsTab = AgencyTab:AddSubTab("Preps", "Preps")

            prepsTab:AddFeature(eFeature.Heist.Agency.Preps.Contract)
            prepsTab:AddFeature(eFeature.Heist.Agency.Preps.Complete)

            local MiscTab = AgencyTab:AddSubTab("Misc", "Misc")
            MiscTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscTab:AddFeature(eFeature.Heist.Generic.Skip)
            MiscTab:AddFeature(eFeature.Heist.Agency.Misc.Finish)
            MiscTab:AddFeature(eFeature.Heist.Agency.Misc.Cooldown)

            local payoutTab = AgencyTab:AddSubTab("Payouts", "Payouts")
            payoutTab:AddFeature(eFeature.Heist.Agency.Payout.Select)
            payoutTab:AddFeature(eFeature.Heist.Agency.Payout.Max)
            payoutTab:AddFeature(eFeature.Heist.Agency.Payout.Apply)
        end

        local ApartmentTab = HeistToolTab:AddSubTab("Apartment", "Apartment")
        if ApartmentTab then
            local PrepsSubTab = ApartmentTab:AddSubTab("Preps", "Preps")
            PrepsSubTab:AddFeature(eFeature.Heist.Apartment.Preps.Complete)
            PrepsSubTab:AddFeature(eFeature.Heist.Apartment.Preps.Reload)
            PrepsSubTab:AddFeature(eFeature.Heist.Apartment.Preps.Change)

            local MiscSubTab = ApartmentTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Launch)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Skip)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.Force)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.Finish)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.FleecaHack)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.FleecaDrill)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.PacificHack)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.Cooldown)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.Play)
            MiscSubTab:AddFeature(eFeature.Heist.Apartment.Misc.Unlock)

            local CutsSubTab = ApartmentTab:AddSubTab("Cuts", "Cuts")
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Team)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Receivers)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Presets)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Bonus)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Double)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Player1)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Player2)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Player3)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Player4)
            CutsSubTab:AddFeature(eFeature.Heist.Apartment.Cuts.Apply)
        end

        local AutoShopTab = HeistToolTab:AddSubTab("Auto Shop", "Auto Shop")
        if AutoShopTab then
            local PrepsSubTab = AutoShopTab:AddSubTab("Preps", "Preps")
            PrepsSubTab:AddFeature(eFeature.Heist.AutoShop.Preps.Contract)
            PrepsSubTab:AddFeature(eFeature.Heist.AutoShop.Preps.Complete)
            PrepsSubTab:AddFeature(eFeature.Heist.AutoShop.Preps.Reload)

            local MiscSubTab = AutoShopTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Skip)
            MiscSubTab:AddFeature(eFeature.Heist.AutoShop.Misc.Finish)
            MiscSubTab:AddFeature(eFeature.Heist.AutoShop.Misc.Cooldown)

            local PayoutSubTab = AutoShopTab:AddSubTab("Payout", "Payout")
            PayoutSubTab:AddFeature(eFeature.Heist.AutoShop.Payout.Select)
            PayoutSubTab:AddFeature(eFeature.Heist.AutoShop.Payout.Max)
            PayoutSubTab:AddFeature(eFeature.Heist.AutoShop.Payout.Apply)
        end

        local CayoPericoTab = HeistToolTab:AddSubTab("Cayo Perico", "Cayo Perico")
        if CayoPericoTab then
            local PrepsSubTab = CayoPericoTab:AddSubTab("Preps", "Preps")
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Difficulty)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Approach)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Loadout)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Primary)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Compound)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Compound)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Arts)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Secondary.Island)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Amount.Island)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Advanced)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Default)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Cash)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Weed)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Coke)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Gold)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Target.Value.Arts)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Complete)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Reset)
            PrepsSubTab:AddFeature(eFeature.Heist.CayoPerico.Preps.Reload)

            local PresetsSubTab = CayoPericoTab:AddSubTab("Presets", "Presets")
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.File)
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.Load)
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.Remove)
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.Refresh)
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.Name)
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.Save)
            PresetsSubTab:AddFeature(eFeature.Heist.CayoPerico.Presets.Copy)

            local MiscSubTab = CayoPericoTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Skip)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Force)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Finish)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.FingerprintHack)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.PlasmaCutterCut)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.DrainagePipeCut)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Bag)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Solo)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Team)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Offline)
            MiscSubTab:AddFeature(eFeature.Heist.CayoPerico.Misc.Cooldown.Online)

            local CutsSubTab = CayoPericoTab:AddSubTab("Cuts", "Cuts")
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Team)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Presets)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Crew)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Player1)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Player2)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Player3)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Player4)
            CutsSubTab:AddFeature(eFeature.Heist.CayoPerico.Cuts.Apply)

            local NonHostTab = CayoPericoTab:AddSubTab("Non-Host", "Non-Host")
            NonHostTab:AddFeature(eFeature.Heist.Generic.Cut)
            NonHostTab:AddFeature(eFeature.Heist.Generic.Apply)
        end

        local CasinoHeistTab = HeistToolTab:AddSubTab("Diamond Casino", "Diamond Casino")
        if CasinoHeistTab then
            local PrepsSubTab = CasinoHeistTab:AddSubTab("Preps", "Preps")
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Difficulty)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Approach)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Gunman)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Loadout)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Driver)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Vehicles)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Hacker)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Masks)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Target)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Complete)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Reset)
            PrepsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Preps.Reload)

            local PresetsSubTab = CasinoHeistTab:AddSubTab("Presets", "Presets")
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.File)
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.Load)
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.Remove)
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.Refresh)
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.Name)
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.Save)
            PresetsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Presets.Copy)

            local MiscSubTab = CasinoHeistTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Launch)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Skip)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.Force)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.Finish)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.FingerprintHack)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.KeypadHack)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.VaultDoorDrill)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.Autograbber)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.Cooldown)
            MiscSubTab:AddFeature(eFeature.Heist.DiamondCasino.Misc.Setup)

            local CutsSubTab = CasinoHeistTab:AddSubTab("Cuts", "Cuts")
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Team)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Presets)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Crew)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Player1)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Player2)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Player3)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Player4)
            CutsSubTab:AddFeature(eFeature.Heist.DiamondCasino.Cuts.Apply)

            local NonHostTab = CasinoHeistTab:AddSubTab("Non-Host", "Non-Host")
            NonHostTab:AddFeature(eFeature.Heist.Generic.Cut)
            NonHostTab:AddFeature(eFeature.Heist.Generic.Apply)
        end

        local DoomsdayTab = HeistToolTab:AddSubTab("Doomsday", "Doomsday")
        if DoomsdayTab then
            local PrepsSubTab = DoomsdayTab:AddSubTab("Preps", "Preps")
            PrepsSubTab:AddFeature(eFeature.Heist.Doomsday.Preps.Act)
            PrepsSubTab:AddFeature(eFeature.Heist.Doomsday.Preps.Complete)
            PrepsSubTab:AddFeature(eFeature.Heist.Doomsday.Preps.Reset)
            PrepsSubTab:AddFeature(eFeature.Heist.Doomsday.Preps.Reload)

            local MiscSubTab = DoomsdayTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Launch)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Skip)
            MiscSubTab:AddFeature(eFeature.Heist.Doomsday.Misc.Force)
            MiscSubTab:AddFeature(eFeature.Heist.Doomsday.Misc.Finish)
            MiscSubTab:AddFeature(eFeature.Heist.Doomsday.Misc.DataHack)
            MiscSubTab:AddFeature(eFeature.Heist.Doomsday.Misc.DoomsdayHack)

            local CutsSubTab = DoomsdayTab:AddSubTab("Cuts", "Cuts")
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Team)
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Presets)
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Player1)
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Player2)
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Player3)
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Player4)
            CutsSubTab:AddFeature(eFeature.Heist.Doomsday.Cuts.Apply)

            local NonHostTab = DoomsdayTab:AddSubTab("Non-Host", "Non-Host")
            NonHostTab:AddFeature(eFeature.Heist.Generic.Cut)
            NonHostTab:AddFeature(eFeature.Heist.Generic.Apply)
        end

        local SalvageYardTab = HeistToolTab:AddSubTab("Salvage Yard", "Salvage Yard")
        if SalvageYardTab then
            local Slot1SubTab = SalvageYardTab:AddSubTab("Slot 1", "Slot 1")
            Slot1SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot1.Robbery)
            Slot1SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot1.Vehicle)
            Slot1SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot1.Modification)
            Slot1SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot1.Keep)
            Slot1SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot1.Apply)

            local Slot2SubTab = SalvageYardTab:AddSubTab("Slot 2", "Slot 2")
            Slot2SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot2.Robbery)
            Slot2SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot2.Vehicle)
            Slot2SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot2.Modification)
            Slot2SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot2.Keep)
            Slot2SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot2.Apply)

            local Slot3SubTab = SalvageYardTab:AddSubTab("Slot 3", "Slot 3")
            Slot3SubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            Slot3SubTab:AddFeature(eFeature.Heist.Generic.Skip)
            Slot3SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot3.Robbery)
            Slot3SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot3.Vehicle)
            Slot3SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot3.Modification)
            Slot3SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot3.Keep)
            Slot3SubTab:AddFeature(eFeature.Heist.SalvageYard.Slot3.Apply)

            local PrepsSubTab = SalvageYardTab:AddSubTab("Preps", "Preps")
            PrepsSubTab:AddFeature(eFeature.Heist.SalvageYard.Preps.Apply)
            PrepsSubTab:AddFeature(eFeature.Heist.SalvageYard.Preps.Complete)
            PrepsSubTab:AddFeature(eFeature.Heist.SalvageYard.Preps.Reset)
            PrepsSubTab:AddFeature(eFeature.Heist.SalvageYard.Preps.Reload)

            local MiscSubTab = SalvageYardTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Heist.Generic.Cutscene)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Cooldown.Kill)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Cooldown.Skip)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Availability.Slot1)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Availability.Slot2)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Availability.Slot3)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Free.Setup)
            MiscSubTab:AddFeature(eFeature.Heist.SalvageYard.Misc.Free.Claim)

            local PayoutSubTab = SalvageYardTab:AddSubTab("Payout", "Payout")
            PayoutSubTab:AddFeature(eFeature.Heist.SalvageYard.Payout.Salvage)
            PayoutSubTab:AddFeature(eFeature.Heist.SalvageYard.Payout.Slot1)
            PayoutSubTab:AddFeature(eFeature.Heist.SalvageYard.Payout.Slot2)
            PayoutSubTab:AddFeature(eFeature.Heist.SalvageYard.Payout.Slot3)
            PayoutSubTab:AddFeature(eFeature.Heist.SalvageYard.Payout.Apply)
        end
    end

    local BusinessToolTab = SilentNightTab:AddSubTab("Business Tool", "Business Tool")
    if BusinessToolTab then
        local BunkerTab = BusinessToolTab:AddSubTab("Bunker", "Bunker")
        if BunkerTab then
            local SaleSubTab = BunkerTab:AddSubTab("Sale", "Sale")
            SaleSubTab:AddFeature(eFeature.Business.Bunker.Sale.Price)
            SaleSubTab:AddFeature(eFeature.Business.Bunker.Sale.NoXp)
            SaleSubTab:AddFeature(eFeature.Business.Bunker.Sale.Sell)

            local MiscSubTab = BunkerTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Business.Bunker.Misc.Open)
            MiscSubTab:AddFeature(eFeature.Business.Bunker.Misc.Supply)
            MiscSubTab:AddFeature(eFeature.Business.Bunker.Misc.Trigger)
            MiscSubTab:AddFeature(eFeature.Business.Bunker.Misc.Supplier)

            local StatsSubTab = BunkerTab:AddSubTab("Stats", "Stats")
            StatsSubTab:AddFeature(eFeature.Business.Bunker.Stats.SellMade)
            StatsSubTab:AddFeature(eFeature.Business.Bunker.Stats.SellUndertaken)
            StatsSubTab:AddFeature(eFeature.Business.Bunker.Stats.Earnings)
            StatsSubTab:AddFeature(eFeature.Business.Bunker.Stats.NoSell)
            StatsSubTab:AddFeature(eFeature.Business.Bunker.Stats.NoEarnings)
            StatsSubTab:AddFeature(eFeature.Business.Bunker.Stats.Apply)
        end

        local HangarCargoTab = BusinessToolTab:AddSubTab("Hangar Cargo", "Hangar Cargo")
        if HangarCargoTab then
            local SaleSubTab = HangarCargoTab:AddSubTab("Sale", "Sale")
            SaleSubTab:AddFeature(eFeature.Business.Hangar.Sale.Price)
            SaleSubTab:AddFeature(eFeature.Business.Hangar.Sale.NoXp)
            SaleSubTab:AddFeature(eFeature.Business.Hangar.Sale.Sell)

            local MiscSubTab = HangarCargoTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Business.Hangar.Misc.Open)
            MiscSubTab:AddFeature(eFeature.Business.Hangar.Misc.Supply)
            MiscSubTab:AddFeature(eFeature.Business.Hangar.Misc.Supplier)
            MiscSubTab:AddFeature(eFeature.Business.Hangar.Misc.Cooldown)

            local StatsSubTab = HangarCargoTab:AddSubTab("Stats", "Stats")
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.BuyMade)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.BuyUndertaken)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.SellMade)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.SellUndertaken)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.Earnings)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.NoBuy)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.NoSell)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.NoEarnings)
            StatsSubTab:AddFeature(eFeature.Business.Hangar.Stats.Apply)
        end

        local NightclubTab = BusinessToolTab:AddSubTab("Nightclub", "Nightclub")
        if NightclubTab then
            local SaleSubTab = NightclubTab:AddSubTab("Sale", "Sale")
            SaleSubTab:AddFeature(eFeature.Business.Nightclub.Sale.Price)

            local SafeSubTab = NightclubTab:AddSubTab("Safe", "Safe")
            SafeSubTab:AddFeature(eFeature.Business.Nightclub.Safe.Fill)
            SafeSubTab:AddFeature(eFeature.Business.Nightclub.Safe.Collect)
            SafeSubTab:AddFeature(eFeature.Business.Nightclub.Safe.Unbrick)

            local MiscSubTab = NightclubTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Business.Nightclub.Misc.Open)
            MiscSubTab:AddFeature(eFeature.Business.Nightclub.Misc.Cooldown)
            MiscSubTab:AddFeature(eFeature.Business.Nightclub.Misc.Setup)

            local PopularitySubTab = NightclubTab:AddSubTab("Popularity", "Popularity")
            PopularitySubTab:AddFeature(eFeature.Business.Nightclub.Popularity.Lock)
            PopularitySubTab:AddFeature(eFeature.Business.Nightclub.Popularity.Max)
            PopularitySubTab:AddFeature(eFeature.Business.Nightclub.Popularity.Min)

            local StatsSubTab = NightclubTab:AddSubTab("Stats", "Stats")
            StatsSubTab:AddFeature(eFeature.Business.Nightclub.Stats.SellMade)
            StatsSubTab:AddFeature(eFeature.Business.Nightclub.Stats.Earnings)
            StatsSubTab:AddFeature(eFeature.Business.Nightclub.Stats.NoSell)
            StatsSubTab:AddFeature(eFeature.Business.Nightclub.Stats.NoEarnings)
            StatsSubTab:AddFeature(eFeature.Business.Nightclub.Stats.Apply)
        end

        local SpecialCargoTab = BusinessToolTab:AddSubTab("Special Cargo", "Special Cargo")
        if SpecialCargoTab then
            local SaleSubTab = SpecialCargoTab:AddSubTab("Sale", "Sale")
            SaleSubTab:AddFeature(eFeature.Business.CrateWarehouse.Sale.Price)
            SaleSubTab:AddFeature(eFeature.Business.CrateWarehouse.Sale.NoXp)
            SaleSubTab:AddFeature(eFeature.Business.CrateWarehouse.Sale.NoCrateback)
            SaleSubTab:AddFeature(eFeature.Business.CrateWarehouse.Sale.Sell)

            local MiscSubTab = SpecialCargoTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Business.CrateWarehouse.Misc.Supply)
            MiscSubTab:AddFeature(eFeature.Business.CrateWarehouse.Misc.Select)
            MiscSubTab:AddFeature(eFeature.Business.CrateWarehouse.Misc.Max)
            MiscSubTab:AddFeature(eFeature.Business.CrateWarehouse.Misc.Buy)
            MiscSubTab:AddFeature(eFeature.Business.CrateWarehouse.Misc.Supplier)
            MiscSubTab:AddFeature(eFeature.Business.CrateWarehouse.Misc.Cooldown)

            local StatsSubTab = SpecialCargoTab:AddSubTab("Stats", "Stats")
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.BuyMade)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.BuyUndertaken)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.SellMade)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.SellUndertaken)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.Earnings)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.NoBuy)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.NoSell)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.NoEarnings)
            StatsSubTab:AddFeature(eFeature.Business.CrateWarehouse.Stats.Apply)
        end

        local MiscTab = BusinessToolTab:AddSubTab("Misc", "Misc")
        if MiscTab then
            local SuppliesSubTab = MiscTab:AddSubTab("Supplies", "Supplies")
            SuppliesSubTab:AddFeature(eFeature.Business.Misc.Supplies.Business)
            SuppliesSubTab:AddFeature(eFeature.Business.Misc.Supplies.Resupply)
        end
    end

    local MoneyToolTab = SilentNightTab:AddSubTab("Money Tool", "Money Tool")
    if MoneyToolTab then
        local CasinoTab = MoneyToolTab:AddSubTab("Casino", "Casino")
        if CasinoTab then
            local LuckyWheelSubTab = CasinoTab:AddSubTab("Lucky Wheel", "Lucky Wheel")
            LuckyWheelSubTab:AddFeature(eFeature.Money.Casino.LuckyWheel.Select)
            LuckyWheelSubTab:AddFeature(eFeature.Money.Casino.LuckyWheel.Give)

            local BlackjackSubTab = CasinoTab:AddSubTab("Blackjack", "Blackjack")
            BlackjackSubTab:AddFeature(eFeature.Money.Casino.Blackjack.Card)
            BlackjackSubTab:AddFeature(eFeature.Money.Casino.Blackjack.Reveal)
            BlackjackSubTab:AddFeature(eFeature.Money.Casino.Blackjack.Trick)

            local SlotMachinesSubTab = CasinoTab:AddSubTab("Slot Machines", "Slot Machines")
            SlotMachinesSubTab:AddFeature(eFeature.Money.Casino.Slots.Win)
            SlotMachinesSubTab:AddFeature(eFeature.Money.Casino.Slots.Lose)

            local PokerSubTab = CasinoTab:AddSubTab("Poker", "Poker")
            PokerSubTab:AddFeature(eFeature.Money.Casino.Poker.MyCards)
            PokerSubTab:AddFeature(eFeature.Money.Casino.Poker.Cards)
            PokerSubTab:AddFeature(eFeature.Money.Casino.Poker.Reveal)
            PokerSubTab:AddFeature(eFeature.Money.Casino.Poker.Give)
            PokerSubTab:AddFeature(eFeature.Money.Casino.Poker.Trick)

            local RouletteSubTab = CasinoTab:AddSubTab("Roulette", "Roulette")
            RouletteSubTab:AddFeature(eFeature.Money.Casino.Roulette.Land13)
            RouletteSubTab:AddFeature(eFeature.Money.Casino.Roulette.Land16)

            local MiscSubTab = CasinoTab:AddSubTab("Misc", "Misc")
            MiscSubTab:AddFeature(eFeature.Money.Casino.Misc.Bypass)
            MiscSubTab:AddFeature(eFeature.Money.Casino.Misc.Limit.Select)
            MiscSubTab:AddFeature(eFeature.Money.Casino.Misc.Limit.Acquire)
            MiscSubTab:AddFeature(eFeature.Money.Casino.Misc.Limit.Trade)
        end

        local MiscTab = MoneyToolTab:AddSubTab("Misc", "Misc")
        if MiscTab then
            local EasyMoneyTab = MiscTab:AddSubTab("Easy Money", "Easy Money")
            EasyMoneyTab:AddFeature(eFeature.Money.EasyMoney.Instant.Give30m)
            EasyMoneyTab:AddFeature(eFeature.Money.EasyMoney.Freeroam._5k)
            EasyMoneyTab:AddFeature(eFeature.Money.EasyMoney.Freeroam._50k)
            EasyMoneyTab:AddFeature(eFeature.Money.EasyMoney.Freeroam._100k)
            EasyMoneyTab:AddFeature(eFeature.Money.EasyMoney.Freeroam._180k)
            EasyMoneyTab:AddFeature(eFeature.Money.EasyMoney.Property._300k)

            local EditSubTab = MiscTab:AddSubTab("Edit", "Edit")
            EditSubTab:AddFeature(eFeature.Money.Misc.Edit.Select)
            EditSubTab:AddFeature(eFeature.Money.Misc.Edit.Deposit)
            EditSubTab:AddFeature(eFeature.Money.Misc.Edit.Withdraw)
            EditSubTab:AddFeature(eFeature.Money.Misc.Edit.Remove)
            EditSubTab:AddFeature(eFeature.Money.Misc.Edit.DepositAll)
            EditSubTab:AddFeature(eFeature.Money.Misc.Edit.WithdrawAll)

            local StorySubTab = MiscTab:AddSubTab("Story", "Story")
            StorySubTab:AddFeature(eFeature.Money.Misc.Story.Select)
            StorySubTab:AddFeature(eFeature.Money.Misc.Story.Character)
            StorySubTab:AddFeature(eFeature.Money.Misc.Story.Apply)

            local StatsSubTab = MiscTab:AddSubTab("Stats", "Stats")
            StatsSubTab:AddFeature(eFeature.Money.Misc.Stats.Select)
            StatsSubTab:AddFeature(eFeature.Money.Misc.Stats.Earned)
            StatsSubTab:AddFeature(eFeature.Money.Misc.Stats.Spent)
            StatsSubTab:AddFeature(eFeature.Money.Misc.Stats.Apply)
        end
    end

    local DevToolTab = SilentNightTab:AddSubTab("Dev Tool", "Dev Tool")
    if DevToolTab then
        local EditorTab = DevToolTab:AddSubTab("Editor", "Editor")
        if EditorTab then
            local GlobalsSubTab = EditorTab:AddSubTab("Globals", "Globals")
            GlobalsSubTab:AddFeature(eFeature.Dev.Editor.Globals.Type)
            GlobalsSubTab:AddFeature(eFeature.Dev.Editor.Globals.Global)
            GlobalsSubTab:AddFeature(eFeature.Dev.Editor.Globals.Value)
            GlobalsSubTab:AddFeature(eFeature.Dev.Editor.Globals.Read)
            GlobalsSubTab:AddFeature(eFeature.Dev.Editor.Globals.Write)
            GlobalsSubTab:AddFeature(eFeature.Dev.Editor.Globals.Revert)

            local LocalsSubTab = EditorTab:AddSubTab("Locals", "Locals")
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Type)
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Script)
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Local)
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Value)
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Read)
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Write)
            LocalsSubTab:AddFeature(eFeature.Dev.Editor.Locals.Revert)

            local StatsSubTab = EditorTab:AddSubTab("Stats", "Stats")
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.From)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Type)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Stat)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Value)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Read)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Write)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Revert)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.File)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.WriteAll)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Remove)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Refresh)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Copy)
            StatsSubTab:AddFeature(eFeature.Dev.Editor.Stats.Generate)

            local PackedStatsSubTab = EditorTab:AddSubTab("Packed Stats", "Packed Stats")
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.Range)
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.Type)
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.PackedStat)
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.Value)
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.Read)
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.Write)
            PackedStatsSubTab:AddFeature(eFeature.Dev.Editor.PackedStats.Revert)
        end
    end

    local SettingsTab = SilentNightTab:AddSubTab("Settings", "Settings")
    if SettingsTab then
        local ConfigSubTab = SettingsTab:AddSubTab("Config & Discord", "Config & Discord")
        ConfigSubTab:AddFeature(eFeature.Settings.Config.Open)
        ConfigSubTab:AddFeature(eFeature.Settings.Config.Logging)
        ConfigSubTab:AddFeature(eFeature.Settings.Config.Reset)
        ConfigSubTab:AddFeature(eFeature.Settings.Config.Copy)
        ConfigSubTab:AddFeature(eFeature.Settings.Config.Discord)

        local TranslationSubTab = SettingsTab:AddSubTab("Translation", "Translation")
        TranslationSubTab:AddFeature(eFeature.Settings.Translation.File)
        TranslationSubTab:AddFeature(eFeature.Settings.Translation.Load)
        TranslationSubTab:AddFeature(eFeature.Settings.Translation.Remove)
        TranslationSubTab:AddFeature(eFeature.Settings.Translation.Refresh)
        TranslationSubTab:AddFeature(eFeature.Settings.Translation.Export)
        TranslationSubTab:AddFeature(eFeature.Settings.Translation.Copy)

        local CollabsSubTab = SettingsTab:AddSubTab("Collabs", "Collabs")
        CollabsSubTab:AddFeature(eFeature.Settings.Collab.JinxScript.Toggle)
        CollabsSubTab:AddFeature(eFeature.Settings.Collab.JinxScript.Discord)
        CollabsSubTab:AddFeature(eFeature.Settings.Collab.JinxScript.Stop)

        local UnlockAllPOISubTab = SettingsTab:AddSubTab("Unlock All POI", "Unlock All POI")
        UnlockAllPOISubTab:AddFeature(eFeature.Settings.UnlockAllPoi.CayoPerico)
        UnlockAllPOISubTab:AddFeature(eFeature.Settings.UnlockAllPoi.DiamondCasino)

        local InstantFinishSubTab = SettingsTab:AddSubTab("Instant Finish", "Instant Finish")
        InstantFinishSubTab:AddFeature(eFeature.Settings.InstantFinish.Agency)
        InstantFinishSubTab:AddFeature(eFeature.Settings.InstantFinish.Apartment)
        InstantFinishSubTab:AddFeature(eFeature.Settings.InstantFinish.AutoShop)
        InstantFinishSubTab:AddFeature(eFeature.Settings.InstantFinish.CayoPerico)
        InstantFinishSubTab:AddFeature(eFeature.Settings.InstantFinish.DiamondCasino)
        InstantFinishSubTab:AddFeature(eFeature.Settings.InstantFinish.Doomsday)

        local EasyMoneySubTab = SettingsTab:AddSubTab("Easy Money", "Easy Money")
        EasyMoneySubTab:AddFeature(eFeature.Settings.EasyMoney.Prevention)
        EasyMoneySubTab:AddFeature(eFeature.Settings.EasyMoney.Delay._5k)
        EasyMoneySubTab:AddFeature(eFeature.Settings.EasyMoney.Delay._50k)
        EasyMoneySubTab:AddFeature(eFeature.Settings.EasyMoney.Delay._100k)
        EasyMoneySubTab:AddFeature(eFeature.Settings.EasyMoney.Delay._180k)
        EasyMoneySubTab:AddFeature(eFeature.Settings.EasyMoney.Delay._300k)
    end
end

Renderer.RenderListGUI()

--#endregion
