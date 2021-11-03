// Copyright (c) 2019-2020 The Open-Transactions developers
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include "otwrap/notary.hpp"  // IWYU pragma: associated

namespace metier
{
const char* introduction_notary_contract_{
    R"(-----BEGIN OT ARMORED SERVER CONTRACT-----
Version: Open Transactions 1.13.0
Comment: http://opentransactions.org

CAISJG90Mjl3UFNFdHFyV2loVUM1YVRGRVp3Z3BxZzJicnE0ZGpXdxokb3QyMkoydkFjcFZO
Q3dFUTJHdzE4SHBDa1NQeDlmUzZZcmJHIiJPcGVuLVRyYW5zYWN0aW9ucyBEaXNjb3Zlcnkg
U2VydmVyKvAMCAYSJG90MjJKMnZBY3BWTkN3RVEyR3cxOEhwQ2tTUHg5ZlM2WXJiRxgCKAIy
UwgCEAIiTQgDEiECECNsSN/k/vUJbAgvYE9/vCcMA4Sx6dWXKYEo85D+pOsaIDaSlqQMflBN
JazcCoj83zEDs3Bdh3EIpVnu1xIvJg8igAEAiAEAOuwLCAYSJG90MjJKMnZBY3BWTkN3RVEy
R3cxOEhwQ2tTUHg5ZlM2WXJiRxokb3QyOFg1UzVrQTY0ZlFab05lQmRzTVNGcHlEd0Z2R2dW
MkpuIAIyswQIBhIkb3QyOFg1UzVrQTY0ZlFab05lQmRzTVNGcHlEd0Z2R2dWMkpuGAIgASgC
MiRvdDIySjJ2QWNwVk5Dd0VRMkd3MThIcENrU1B4OWZTNllyYkdCXQgCElMIAhACIk0IAxIh
AhAjbEjf5P71CWwIL2BPf7wnDAOEsenVlymBKPOQ/qTrGiA2kpakDH5QTSWs3AqI/N8xA7Nw
XYdxCKVZ7tcSLyYPIoABAIgBABoECAEQAkqdAQgCEAIaMQgCEAMYAiABKiEDvgNLXNFyUhkO
kIoReOSL9PYbBTcUwTqKUsffuP2d1JZI9rKYwg8aMQgCEAMYAiACKiEDeM7hnv1M69Fi/WWT
3TIPOXuCKWKqH+q2iYauqsdbDcFI9rKYwg8aMQgCEAMYAiADKiEDKqADpj4025+EEI8nVFJB
j5zIDU4iIUteZSJOO9mg8PVI9rKYwg96bggBEiRvdDI4WDVTNWtBNjRmUVpvTmVCZHNNU0Zw
eUR3RnZHZ1YySm4YASAFKkA/H0Lr1GGW/1uzoEq3pkxerFlb4H/Laz87aQfwZ5meIoPULNTs
vk9m5yhAYPXd18gzo0Lg5LiVwQII2b7eIg12em4IARIkb3QyMkoydkFjcFZOQ3dFUTJHdzE4
SHBDa1NQeDlmUzZZcmJHGAMgBSpAfH4+MZvctcpPDVAyst17q1P7GxHzAZ5sRwEKnxvRaB2v
O9Ye1r/iMldIgk3YggQvXNqTVmMdzGKAW1kntf7VCUL8AwgGEiNvdG9wcmlmVG1HdGd2UHFX
RG9NM1d6THpxRnJ5VHIyRnVWQxgCIAIoAjIkb3QyMkoydkFjcFZOQ3dFUTJHdzE4SHBDa1NQ
eDlmUzZZcmJHOigIARIkb3QyOFg1UzVrQTY0ZlFab05lQmRzTVNGcHlEd0Z2R2dWMkpuSp0B
CAIQAhoxCAIQAxgCIAEqIQO9L6bkuSes2sCDqCiaKnZW/k9E1ghqqEBz3WC0Tz8fIEjqqpyl
CBoxCAIQAxgCIAIqIQMbsZwSi9acmxbdg7N+1Qm2sHaYJZUIMZFHCDIh4orHLUjqqpylCBox
CAIQAxgCIAMqIQI1GAp4MULdVrmuKToXG0CjQdCb/nSMoup+A5iSxsT5FkjqqpylCHptCAES
I290b3ByaWZUbUd0Z3ZQcVdEb00zV3pMenFGcnlUcjJGdVZDGAEgBSpAFohlPVxGmi9q5nrp
6lkoZnFkCqpDAVg4pYje/594ZlDfQbRuGBGLr46GqOjHEYgNetlZIPTcuxHVvXEzsPYcAHpu
CAESJG90MjhYNVM1a0E2NGZRWm9OZUJkc01TRnB5RHdGdkdnVjJKbhgBIAUqQE1hhHCg+zav
zI/DKwjFsHMkG8K84B3UJ5YbnK3s26A6uSTv/nK/HAJ2U8hH41aLihJYcqrqmePuPPYiEr/O
dj9C5AIIBhIkb3QyMTg5d1NoaG1EWnJQM3VGM3QyaFZkSHNiMzJwRUVhc1pDGAIgAygBMiRv
dDIySjJ2QWNwVk5Dd0VRMkd3MThIcENrU1B4OWZTNllyYkc6KAgBEiRvdDI4WDVTNWtBNjRm
UVpvTmVCZHNNU0ZweUR3RnZHZ1YySm5adAgGEjYIBhABGjAIBhgFIiJPcGVuLVRyYW5zYWN0
aW9ucyBEaXNjb3ZlcnkgU2VydmVyKAAwADgBOAISOAgGEAIaMggGGA0iJG90Mjl3UFNFdHFy
V2loVUM1YVRGRVp3Z3BxZzJicnE0ZGpXdygAMAA4ATgCem4IARIkb3QyOFg1UzVrQTY0ZlFa
b05lQmRzTVNGcHlEd0Z2R2dWMkpuGAEgBSpA4+Q8k3XxBXd/oIfcVIjay7asTwXphHR7E0ke
0CFSnzR3+h5o4KwLdySDkczUzyNucDCUPw5zQCLxAEaRPvbUGjIXCAEQARgBIgw1NC4zOS4x
MjkuNDUorTcyHwgBEAIYASIUMjYwNzo1MzAwOjIwMzo0MDJkOjoorTc6fENvbXBsaW1lbnRh
cnkgaG9zdGluZyBvZiBueW1zIGFuZCBvdGhlciBvcGVudHhzIGlkZW50aWZpY2F0aW9uIGNv
bnRyYWN0cy4gTm8gbWVzc2FnaW5nIG9yIGZpbmFuY2lhbCB0cmFuc2FjdGlvbnMgaXMgZW5h
YmxlZC5CIJolw7EGFI7d8/eBhdGvmLm71YsI//6vR1AN0R5M7CAFSm0IARIjb3RvcHJpZlRt
R3RndlBxV0RvTTNXekx6cUZyeVRyMkZ1VkMYBSAFKkAX0OBcNXhfPPL+VjKejhN7OX0PlCxO
8Lj0Aax8pKSF55dtKDA8+FIx7gAj56NKRkoS+LPO4mYZ8NcnjGgM2JYS
-----END OT ARMORED SERVER CONTRACT-----)"};

const char* messaging_notary_contract_{
    R"(-----BEGIN OT ARMORED SERVER CONTRACT-----
Version: Open Transactions 1.13.0
Comment: http://opentransactions.org

CAISI290d2FkRDlQUHVpUHk3Tlc5WmlVSExRUkJYY1VUenJFYnpnGiNvdG92QnFpYTcxNDMy
OWZ1ODl3WkRmamVXTHF2WVVQTU5NdyIZTWF0dGVyRmkgTWVzc2FnaW5nIE5vdGFyeSrbDAgG
EiNvdG92QnFpYTcxNDMyOWZ1ODl3WkRmamVXTHF2WVVQTU5NdxgCKAIyUwgCEAIiTQgDEiEC
qimosVc61jE+c7OLk20Hh4iYukcL7vBCn6oIZ0Xp1dwaIMJOseLYAtID0hJV4vwOSMV6gd2S
AnPokinhQsUPdW7IgAEAiAEAOtgLCAYSI290b3ZCcWlhNzE0MzI5ZnU4OXdaRGZqZVdMcXZZ
VVBNTk13GiNvdHRGaFF1M2tzSG94b0toUWNKcFJjMmttU2UycXJHMnVNZSACMq8ECAYSI290
dEZoUXUza3NIb3hvS2hRY0pwUmMya21TZTJxckcydU1lGAIgASgCMiNvdG92QnFpYTcxNDMy
OWZ1ODl3WkRmamVXTHF2WVVQTU5Nd0JdCAISUwgCEAIiTQgDEiECqimosVc61jE+c7OLk20H
h4iYukcL7vBCn6oIZ0Xp1dwaIMJOseLYAtID0hJV4vwOSMV6gd2SAnPokinhQsUPdW7IgAEA
iAEAGgQIARACSp0BCAIQAhoxCAIQAxgCIAEqIQJc0fK5qOPf0kGYoF6y1FwJf1NLD8QuAixd
sj862y1tY0j9s9znCBoxCAIQAxgCIAIqIQKGbWaUXcX00ZKCuV/6tBOIwEfYfYpZVrd40RYl
eSLdCUj9s9znCBoxCAIQAxgCIAMqIQKXCSYP752dY+cjdSiYenR607w5Ha3YBvKx2IUR0HG5
L0j9s9znCHptCAESI290dEZoUXUza3NIb3hvS2hRY0pwUmMya21TZTJxckcydU1lGAEgBSpA
X1K6Is0LBz5lIgSuRxE/0vMVZJ7huyGOiIDEeAGxhbFq4s10Ssk9FdwEZ3QVRaj9PMDAZzHH
4SnTKNrNaApFGHptCAESI290b3ZCcWlhNzE0MzI5ZnU4OXdaRGZqZVdMcXZZVVBNTk13GAMg
BSpAKuKAu7Ihzug3H94A/NzfU/s7ejAW0uebcbYzCGu9yBOaHYfAoHnCsLjVu2XA5RpauxNN
t0MWPFGYnJzwlKGpJkL7AwgGEiRvdDI3aWF2R0d5aHB4N2RuMm95SG9DQW9lVWJKQTd0YzM5
bjUYAiACKAIyI290b3ZCcWlhNzE0MzI5ZnU4OXdaRGZqZVdMcXZZVVBNTk13OicIARIjb3R0
RmhRdTNrc0hveG9LaFFjSnBSYzJrbVNlMnFyRzJ1TWVKnQEIAhACGjEIAhADGAIgASohAz9n
XxcoICe3GQ+KRJFdwdaPbGi3WisrxfcE3fWli5mOSOiIotYMGjEIAhADGAIgAiohAxeDENSn
JBCW/Y8D8IqfasoJhaU2yL5wcGShHmpJdfX+SOiIotYMGjEIAhADGAIgAyohAyN3rc+fRC1o
ltBb8eJWDw5Ocemj/kOmvy04pjIHoRtSSOiIotYMem4IARIkb3QyN2lhdkdHeWhweDdkbjJv
eUhvQ0FvZVViSkE3dGMzOW41GAEgBSpAH25Hgs5Vw6J/TKCZutRiALg9w9yUefIEyD9w0Qlm
gXYVF5xVaCv/XouhrTaMICmsHgY3AMCR1658pTNIPlWiOXptCAESI290dEZoUXUza3NIb3hv
S2hRY0pwUmMya21TZTJxckcydU1lGAEgBSpAM//X507AtsqXiCsa29Xxcq01VftxjZaBlPNQ
2EGRzcgpgbGiCVc1tQTMoaXEs77oPy6yNATAXi0+fPc0VupiR0LXAggGEiRvdDI5TWFEcDR1
U1FIcFNMaWRRcEJKUGJHaUhxTmpNeFh3SlYYAiADKAEyI290b3ZCcWlhNzE0MzI5ZnU4OXda
RGZqZVdMcXZZVVBNTk13OicIARIjb3R0RmhRdTNrc0hveG9LaFFjSnBSYzJrbVNlMnFyRzJ1
TWVaaggGEi0IBhABGicIBhgFIhlNYXR0ZXJGaSBNZXNzYWdpbmcgTm90YXJ5KAAwADgBOAIS
NwgGEAIaMQgGGA0iI290d2FkRDlQUHVpUHk3Tlc5WmlVSExRUkJYY1VUenJFYnpnKAAwADgB
OAJ6bQgBEiNvdHRGaFF1M2tzSG94b0toUWNKcFJjMmttU2UycXJHMnVNZRgBIAUqQKscgY+F
fKwREea4uoIl4HPncLeCAmSLMaJ/1XMxij2TPeUs7XmbO1qtb09CWarR3lm4EWKSijr82jVr
NQjj0m8yFggBEAEYASILNDAuODguMzUuNzIorTc6W0NvbXBsaW1lbnRhcnkgbWVzc2FnaW5n
IG5vdGFyeSBwcm92aWRlZCBieSBNYXR0ZXJGaS4gTm8gZmluYW5jaWFsIHRyYW5zYWN0aW9u
cyBhcmUgZW5hYmxlZC5CIEfQvYaZ846Bkg1c3DvbbUlN8im1Bd4fFk9YbLggGg5zSm4IARIk
b3QyN2lhdkdHeWhweDdkbjJveUhvQ0FvZVViSkE3dGMzOW41GAUgBSpAdUoYgO0LsTxH/QWn
8PdWaZ0ka2Jhwl0NwlgDxS9212pHpH58Cr49PJ8SbnBjx2GJevwaT5G15HKs4WuL4x3ZUg==

-----END OT ARMORED SERVER CONTRACT-----)"};
}  // namespace metier
