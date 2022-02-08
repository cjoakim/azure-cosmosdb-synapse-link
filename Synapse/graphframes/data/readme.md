## IMDb Values of Interest

### Actors/Actresses

```
nm0000102 = kevin_bacon
nm0000113 = sandra_bullock
nm0000126 = kevin_costner
nm0000148 = harrison_ford
nm0000152 = richard_gere
nm0000158 = tom_hanks
nm0000163 = dustin_hoffman
nm0000178 = diane_lane
nm0000206 = keanu_reeves
nm0000210 = julia_roberts
nm0000234 = charlize_theron
nm0000456 = holly_hunter
nm0000518 = john_malkovich
nm0000849 = javier_bardem
nm0001648 = charlotte_rampling
nm0001742 = lori_singer
nm0001848 = dianne_wiest
nm0005476 = hilary_swank
nm0177896 = bradley_cooper
nm0205626 = viola_davis
nm1297015 = emma_stone
nm2225369 = jennifer_lawrence
```

### Movies

```
tt0083658 = bladerunner
tt0087089 = cotton_club
tt0087277 = footloose
tt0100405 = pretty_woman
```

### Grep

```
$ cat imdb_vertices.csv | grep nm0000102
nm0000102|Person|Kevin Bacon|{"row_idx": 2725}

$ cat imdb_vertices.csv | grep nm0001648
nm0001648|Person|Charlotte Rampling|{"row_idx": 3330}

$ cat imdb_vertices.csv | grep tt0087277
tt0087277|Movie|Footloose|{"year": 1984, "minutes": 107, "row_idx": 1560}

$ cat imdb_edges.csv | grep tt0087277
tt0087277|nm0000102|has_person|{"src_label": "Movie", "dst_label": "Person", "row_idx": 6283}
tt0087277|nm0001742|has_person|{"src_label": "Movie", "dst_label": "Person", "row_idx": 6284}
tt0087277|nm0001475|has_person|{"src_label": "Movie", "dst_label": "Person", "row_idx": 6285}
tt0087277|nm0001848|has_person|{"src_label": "Movie", "dst_label": "Person", "row_idx": 6286}
nm0000102|tt0087277|is_in|{"src_label": "Person", "dst_label": "Movie", "row_idx": 6283}
nm0001742|tt0087277|is_in|{"src_label": "Person", "dst_label": "Movie", "row_idx": 6284}
nm0001475|tt0087277|is_in|{"src_label": "Person", "dst_label": "Movie", "row_idx": 6285}
nm0001848|tt0087277|is_in|{"src_label": "Person", "dst_label": "Movie", "row_idx": 6286}
```
