# Plán úprav repozitáře Functional

Stav: schváleno autorem (2026-10-14), provedeno.
Ověření: Haskell soubory načteny v GHC 9.6, Prolog soubory v SWI-Prologu 9.2.9 (kontejnery přes Podman, viz `compose.yaml`) bez chyb; opravené predikáty a funkce ověřeny ukázkovými dotazy. Gödel **neověřen** (není dostupná implementace).

## 1. Struktura a přejmenování

Přesuny přes `git mv`, aby zůstala zachovaná historie.

| Původní soubor | Nové umístění |
|---|---|
| `binaryTree.hs` | `haskell/binary-search-tree.hs` |
| `lambdaCalcul.hs` | `haskell/lambda-calculus.hs` |
| `files.hs` | `haskell/file-io-exercises.hs` |
| `binT_Key.prolog` | `prolog/binary-tree-with-key.pl` |
| `binT_noKey.prolog` | `prolog/binary-tree-without-key.pl` |
| `lambdaCalcul.prolog` | `prolog/lambda-calculus.pl` |
| `seznamy.prolog` | `prolog/list-operations.pl` |
| `godel.glsl` | `goedel/fibonacci-prime-gcd.gdl` |

- `.pl` je standardní přípona pro SWI-Prolog.
- `godel.glsl` je ve skutečnosti jazyk Gödel, ne GLSL shader; zvolena přípona `.gdl`.

## 2. Opravy chyb

### Chyby
1. `binT_noKey.prolog`, poslední klauzule `add2tree`: argumenty jsou prohozené, `add2tree(Vnew, RR, R)` má být `add2tree(Vnew, R, RR)`. Vkládání do pravého podstromu proto nefunguje. Komentář „pridani do prava“ je u větve pro levý podstrom.
2. `lambdaCalcul.prolog`, predikát `vazane/2`: volá neexistující `azImpl`, má být `vazImpl`. Nefunguje tím ani `isvalid`.
3. `binT_Key.prolog`, `posOrder`: druhá klauzule čeká `[]`, ale prázdný strom je `leaf`, takže se nikdy nepoužije. `append([LL|RL], …)` vrací vnořený seznam místo plochého.
4. `binT_noKey.prolog`, `posOrder`: `append([LL,RR], [V], List)` vrací vnořený seznam.
5. `seznamy.prolog`: řádky `?- …` se spustí už při načtení souboru. `takeWhile(odd, …)` běží dřív, než je `odd` definovaný. Převést je na komentáře `%?- …`.
6. `files.hs`: `import IO` (Haskell 98) nahradit `import System.IO`.
7. `lambdaCalcul.hs`, `eta`: chybí větev pro ostatní tvary výrazu, jinak funkce spadne.

### Drobnosti
8. `seznamy.prolog`: komentář u `takeWhile` uvádí výsledek `[1,3,5,7]`, správně je `[1,3,5]`.
9. `lambdaCalcul.hs`: `isValidSubst` a `subst` kontrolují podmínku každá jinak (volná proměnná vs. nevázaná). Sjednotit.
10. `binaryTree.hs`, `treeUpValue`: podmínka, která nikdy neplatí, a chybí větev pro `Empty`.
11. `lambdaCalcul.prolog`: nesmyslná a nepoužívaná definice `lE/1`. Opravit nebo odstranit.
12. `binaryTree.hs`: převést z ISO-8859-2 do UTF-8, protože hlavička se zobrazuje rozbitě.
13. Opravit překlepy v komentářích, např. „BINARNI STORM“ → „STROM“.
14. Sjednotit konce řádků na LF přes `.gitattributes`.
15. Dočíst celý `files.hs` a případné nálezy doplnit. (Dočteno, další chyby nenalezeny; GHC hlásí jen varování na tabulátory.)
16. `godel.glsl`: oddělovače `#####` nahradit komentáři `%`, opravit `Prime` pro čísla ≤ 1 (`prime > 1 &`).
17. Převést Gödel příklad do Prologu (`prolog/fibonacci-prime-gcd.pl`), originál ponechat v `goedel/`.
18. Přidat `compose.yaml` pro ověření v kontejnerech (Haskell, SWI-Prolog).

Kód se jinak nerefaktoruje, zůstane ve stylu studijních příkladů.

## 3. `.gitignore`

Ponechat `.ai/support-plan.md` a `CLAUDE.md`, doplnit:

```
# Haskell
*.hi
*.o
*.exe
dist-newstyle/
.stack-work/

# Editors
.vscode/
.idea/
*~
*.swp
```

## 4. `README.md` (markdown, česky)

- **Úvod:** sbírka studijních ukázek funkcionálního a logického programování. Nejde o knihovnu ani produkční kód.
- **Tabulka příkladů:** soubor, jazyk a co ukazuje: BST, průchody stromem, lambda kalkul (volné a vázané proměnné, α/β/η konverze, substituce), operace se seznamy, souborové I/O, Fibonacci, prvočísla a NSD v Gödelu.
- **Jak spustit:** `ghci haskell/binary-search-tree.hs`, `swipl prolog/list-operations.pl`, ukázkové dotazy převzaté z komentářů v kódu.
- **Poznámka:** komentáře v kódu jsou česky, z let 2011–2012.

## 5. Postup

1. Přesuny a přejmenování.
2. Opravy chyb.
3. `README.md`, `.gitignore`, `.gitattributes`.

Commit až po potvrzení autora, bez push.
