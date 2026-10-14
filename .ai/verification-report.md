# Výsledky ověření příkladů

Datum: 2026-10-14
Prostředí: kontejnery přes Podman (`compose.yaml`): `haskell:9.6` (GHC 9.6), `swipl:9.2.9` (SWI-Prolog 9.2.9).

## Shrnutí

| Jazyk | Soubory | Výsledek |
|---|---|---|
| Haskell | 3 | ✅ všechny se načtou bez chyb, funkce ověřeny dotazy |
| Prolog | 5 | ✅ všechny se načtou bez chyb, predikáty ověřeny dotazy |
| Gödel | 1 | ⚠️ **neověřeno** spuštěním, kontrola čtením; převod do Prologu ověřen |

`docker compose up` / `podman compose up`: služba `haskell` → `Haskell: OK`, služba `prolog` → `Prolog: OK`, obě skončily s kódem 0.

## Haskell

Načtení: `ghc -v0 -e "return ()" <soubor>`. Jediná varování jsou tabulátory (`-Wtabs`) v `file-io-exercises.hs` a `lambda-calculus.hs`, na funkčnost nemají vliv.

### `haskell/binary-search-tree.hs`

| Výraz | Výsledek |
|---|---|
| `treeInorder (treeFromList [3,1,2])` | `[1,2,3]` |
| `treeUpValue (Empty :: BTree Int)` | `Empty` (dřív chyběla větev) |
| `treeRemoveElem (-2) (Node 0 (Node (-1) (Node (-2) Empty Empty) Empty) Empty)` | `Node 0 (Node (-1) Empty Empty) Empty` |

### `haskell/lambda-calculus.hs`

| Výraz | Výsledek |
|---|---|
| `freeVars` pro `\xyz.xa` | `["a"]` |
| `boundVars` pro `\xyz.xa` | `["x"]` |
| `alpha` (x → X) na `\xyz.xa` | `LAbs "X" (LAbs "y" (LAbs "z" (LApp (LVar "X") (LVar "a"))))` |
| `subst (LAbs "x" (LVar "y")) (LVar "y") (LApp (LVar "a") (LVar "b"))` | `LAbs "x" (LApp (LVar "a") (LVar "b"))` |
| `beta (\x.\z.x z) (a b)` | `LAbs "z" (LApp (LApp (LVar "a") (LVar "b")) (LVar "z"))` |
| `eta (\z.(a b) z)` | `LApp (LVar "a") (LVar "b")` |
| `eta (LVar "x")` | `LVar "x"` (dřív pád) |
| `isValidSubst (LAbs "x" (LVar "y")) (LVar "y") (LVar "a")` | `True` |

### `haskell/file-io-exercises.hs`

Načte se bez chyb (`import System.IO`). Funkce pracují se soubory; spuštěním s testovacími soubory **neověřeno**.

## Prolog

Načtení: `swipl --on-error=status -q -g halt <soubor>`. Jediná varování jsou nepoužité proměnné (`Singleton variables`) v `list-operations.pl:13` a `:15`.

| Soubor | Dotaz | Výsledek |
|---|---|---|
| `binary-tree-without-key.pl` | `list2tree([3,1,5,4],T), inOrder(T,L), posOrder(T,P)` | `L = [1,3,4,5]`, `P = [3,1,5,4]` (plochý seznam, vkládání doprava funguje) |
| `binary-tree-with-key.pl` | `list2tree([3,1,2],T), posOrder(T,P), inOrder(T,I)` | `P = [1,3,2]`, `I = [1,2,3]` |
| `lambda-calculus.pl` | `vazane` / `volne` pro `λx.(x y)` | `[x]` / `[y]` (dřív pád na `azImpl`) |
| `lambda-calculus.pl` | `isvalid(z, λx.(x y), w)` | `true` |
| `lambda-calculus.pl` | `isvalid(z, λx.x, x)` | `false` |
| `list-operations.pl` | `takeWhile(odd,[1,3,5,6,7,9],L)` | `[1,3,5]` |
| `list-operations.pl` | `filter(even,[1,2,3,4,5,6],R)` | `[2,4,6]` |
| `list-operations.pl` | `sum([1,2,3],S)`, `rev([1,2,3],R)` | `6`, `[3,2,1]` |

## Gödel — `goedel/fibonacci-prime-gcd.gdl`

**Neověřeno spuštěním.** Pro Gödel (původně nad SICStus Prologem) není dostupný image ani balíček. Kontrola pouze čtením kódu (2026-10-14).

### Struktura souboru

- Soubor obsahuje tři moduly (`Fibonacci`, `PRIME`, `GCD`). Gödel podle všeho očekává jeden `MODULE` na soubor (název modulu = název souboru), takže soubor v současné podobě nejspíš nejde načíst. **Neověřeno.**
- Oddělovače `#####` (ř. 23, 33) nejsou platná syntaxe ani komentář; komentář v Gödelu je `%`.

### Modul `Fibonacci` (ř. 4–21) — logika správná

Ruční průchod `FibIt(k, f, g, n)` (f, g = dvě poslední hodnoty):

| Dotaz | Průchod | Výsledek | Očekáváno |
|---|---|---|---|
| `Fib(0,n)` | fakt | 0 | 0 |
| `Fib(1,n)` | fakt | 1 | 1 |
| `Fib(2,n)` | `FibIt(0,1,1,n)` | 1 | 1 |
| `Fib(3,n)` | `FibIt(1,1,1,n)` → `FibIt(0,1,2,n)` | 2 | 2 |
| `Fib(4,n)` | `FibIt(2,1,1,n)` → `FibIt(1,1,2,n)` → `FibIt(0,2,3,n)` | 3 | 3 |

- Klauzule se nepřekrývají (`k > 1` vs. fakta pro 0 a 1), záporné `k` správně selže.
- Podmínka `g < n` (ř. 20) slouží k ořezání, když je `n` zadané (`Fib(k, 21)`). Při nezadaném `n` spoléhá na odložení/omezení v modulu `Integers`. **Neověřeno**, zda to Gödel takto vyhodnotí.

### Modul `PRIME` (ř. 25–30) — **chyba**

`Prime(prime) <- ~ SOME [x] (x > 1 & x < prime & prime Mod x = 0).`

- Pro `prime` ≤ 1 neexistuje žádné `x` v rozsahu, negace uspěje → `Prime(0)`, `Prime(1)` i záporná čísla vyjdou jako prvočísla.
- Oprava: přidat `prime > 1 &` před negaci.
- Pro `prime` ≥ 2 je definice správná (`Prime(2)` uspěje, `Prime(4)` selže na `x = 2`).

### Modul `GCD` (ř. 35–51) — logika správná

- `CommonDivisor`: pro `i = 0` nebo `j = 0` vrací `Max(Abs(i), Abs(j))` (tj. `Gcd(0, 0) = 0`, `Gcd(0, 6) = 6`), jinak všechny `d` z `1..Min(|i|, |j|)` dělící obě čísla. Záporné vstupy ošetřeny přes `Abs`.
- `Gcd`: společný dělitel, nad kterým už žádný větší neexistuje → největší společný dělitel. Např. `Gcd(12, 18, d)` → kandidáti 1, 2, 3, 6 → `d = 6`.
- Řetězené porovnání `1 =< d =< Min(...)` (ř. 49) je syntaxe Gödelu pro omezení rozsahu. **Neověřeno.**

### Provedeno

1. `#####` nahrazeny komentáři `%`.
2. `Prime` opraven: `prime > 1 &` před negací.
3. Soubor ponechán v jednom kusu (tři moduly), originál zachován v `goedel/`.

## Převod do Prologu — `prolog/fibonacci-prime-gcd.pl`

Převod Gödel příkladu, ověřený v SWI-Prologu 9.2.9. Oproti Gödelu chybí ořezání `g < n` ve `fib_it`, protože aritmetika v Prologu potřebuje navázané `N`.

| Dotaz | Výsledek |
|---|---|
| `fib(K, N)` pro K = 0, 1, 2, 3, 4, 10 | 0, 1, 1, 2, 3, 55 |
| `fib(10, 55)` | `true` |
| `prime(P)` pro P = −2..20 | `[2,3,5,7,11,13,17,19]` (0, 1 a záporná čísla nejsou prvočísla) |
| `gcd(12,18)`, `gcd(0,6)`, `gcd(0,0)`, `gcd(-12,18)`, `gcd(7,13)` | 6, 6, 0, 6, 1 |
| `gcd(12, 18, 3)` | `false` |
