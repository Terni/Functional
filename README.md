# Functional

Sbírka studijních ukázek funkcionálního a logického programování v jazycích **Haskell**, **Prolog** a **Gödel**.

> Jde o výukové příklady (převážně z let 2011–2012), ne o knihovnu ani produkční kód. Komentáře v kódu jsou česky.

## Obsah

| Soubor | Jazyk | Co ukazuje |
|---|---|---|
| [`haskell/binary-search-tree.hs`](haskell/binary-search-tree.hs) | Haskell | Binární vyhledávací strom: vkládání, hledání, mazání, hloubka, cesta k prvku, průchody pre/in/post-order |
| [`haskell/lambda-calculus.hs`](haskell/lambda-calculus.hs) | Haskell | Lambda kalkul: volné a vázané proměnné, α-konverze, substituce, β-redukce, η-konverze |
| [`haskell/file-io-exercises.hs`](haskell/file-io-exercises.hs) | Haskell | Práce se soubory (`System.IO`): náhrada šablony, kontrola aⁿbⁿcⁿ, zalamování textu, počítání řádků a slov |
| [`prolog/binary-tree-with-key.pl`](prolog/binary-tree-with-key.pl) | Prolog | Binární strom s klíčem a hodnotou: vkládání, převod ze seznamu, hloubka, průchody, hledání podle klíče |
| [`prolog/binary-tree-without-key.pl`](prolog/binary-tree-without-key.pl) | Prolog | Binární strom bez klíče: vkládání, průchody, hledání, podstromy, substituce hodnot podle predikátu |
| [`prolog/lambda-calculus.pl`](prolog/lambda-calculus.pl) | Prolog | Lambda kalkul: volné a vázané proměnné, platnost substituce |
| [`prolog/list-operations.pl`](prolog/list-operations.pl) | Prolog | Operace se seznamy: delete, průnik, sjednocení, range, take/drop/takeWhile, map, filter, foldr/foldl |
| [`prolog/fibonacci-prime-gcd.pl`](prolog/fibonacci-prime-gcd.pl) | Prolog | Fibonacci, prvočísla a největší společný dělitel (převod Gödel příkladu) |
| [`goedel/fibonacci-prime-gcd.gdl`](goedel/fibonacci-prime-gcd.gdl) | Gödel | Moduly Fibonacci, prvočísla a největší společný dělitel |

## Jak spustit

### Haskell (GHC)

```sh
ghci haskell/binary-search-tree.hs
```

```haskell
ghci> treeInorder (treeFromList [3, 1, 2])
[1,2,3]
```

### Prolog (SWI-Prolog)

```sh
swipl prolog/list-operations.pl
```

```prolog
?- filter(even, [1,2,3,4,5,6], R).
R = [2, 4, 6].
```

Další ukázkové dotazy jsou v komentářích přímo u jednotlivých predikátů a funkcí (`%?- ...`, `-- pouziti: ...`).

### Gödel

Soubor slouží jako ukázka syntaxe jazyka Gödel a spuštěním není ověřen (implementace Gödelu není běžně dostupná). Ověřitelný převod do Prologu je v `prolog/fibonacci-prime-gcd.pl`.

### Ověření v kontejnerech

Bez lokální instalace GHC a SWI-Prologu lze ověřit, že se všechny příklady načtou bez chyb:

```sh
docker compose up        # nebo: podman compose up
```

Služba `haskell` používá image `haskell:9.6`, služba `prolog` image `swipl:9.2.9`.

## Licence

[MIT](LICENSE) © Terni
