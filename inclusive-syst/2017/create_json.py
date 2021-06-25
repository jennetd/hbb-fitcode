import json

SF = {
    '2018': {
        'V_SF': 0.931,
        'V_SF_ERR': 0.017,
        'shift_SF': 1.006,
        'shift_SF_ERR': 0.002,
        'smear_SF': 0.880,
        'smear_SF_ERR': 0.048,
        'BB_SF': 1,  # 1.0,
        'BB_SF_ERR': .3,  # 0.3,  # prelim ddb SF
    },
    '2017': {
        'V_SF': 0.897,
        'V_SF_ERR': 0.028,
        'shift_SF': 0.992,
        'shift_SF_ERR': 0.0035,
        'smear_SF': 0.944,
        'smear_SF_ERR': 0.047,
        'BB_SF': 1,  # 1.0,                                                                                                               
        'BB_SF_ERR': .3,  # 0.3,  # prelim ddb SF                                                                                         
    },
    '2016': {
        'V_SF': 0.895,
        'V_SF_ERR': 0.024,
        'shift_SF': 0.988,
        'shift_SF_ERR': 0.003,
        'smear_SF': 0.892,
        'smear_SF_ERR': 0.047,
        'BB_SF': 1,  # 1.0,
        'BB_SF_ERR': .3,  # 0.3,  # prelim ddb SF
    }
}

with open('sf.json', 'w') as outfile:
    json.dump(SF, outfile)
