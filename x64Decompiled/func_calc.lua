F_CALC = {}
function F_CALC.SafeNumToStr(a)
  if type(a) == "number" then
    return X2Util:NumberToString(a)
  end
  return a
end
function F_CALC.AddNum(left, right)
  left = F_CALC.SafeNumToStr(left)
  right = F_CALC.SafeNumToStr(right)
  return X2Util:StrNumericAdd(left, right)
end
function F_CALC.SubNum(left, right)
  left = F_CALC.SafeNumToStr(left)
  right = F_CALC.SafeNumToStr(right)
  return X2Util:StrNumericSub(left, right)
end
function F_CALC.MulNum(left, right)
  left = F_CALC.SafeNumToStr(left)
  right = F_CALC.SafeNumToStr(right)
  return X2Util:StrNumericMul(left, right)
end
function F_CALC.CompNum(left, right)
  left = F_CALC.SafeNumToStr(left)
  right = F_CALC.SafeNumToStr(right)
  return X2Util:StrNumericComp(left, right)
end
function F_CALC.Round(num, numDecimalPlaces)
  local mult = 10 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
