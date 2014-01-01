NR == editid {
  if (length(familyname) > 0)
    $1 = familyname
  if (length(name) > 0)
    $2 = name
  if (length(address) > 0)
    $3 = address
  if (length(age) > 0)
    $4 = age
  print $0
}
NR != editid {
  print $0
}
