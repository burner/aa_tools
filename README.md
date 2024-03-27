# Associative Array Tools

Access nested associate array along the path given via the variadic arguments.
```dlang
auto nestedAccess(AA,Args...)(ref AA aa, Args args) {
```

Insert into a nested associate array along the path given via the variadic 
arguments.
```dlang
void nestedInsert(AA,T,Args...)(ref AA aa, auto ref T toInsert, Args args) {
```

Combine `into` and `toInsert` in `into`.
```dlang
void insertInto(AA)(ref AA into, ref AA toInsert) {
```
