use atleti new
use tempi new
zap

sele atleti
do while !eof()
   sele tempi
   for k := 1 to 6
      do case
         case k == 1
            src_iscr := "atleti->t_iscr6"
            src_gara := "atleti->t_gara6"
            src_punt := "atleti->p_gara6"
         case k == 2
            src_iscr := "atleti->t_iscr4"
            src_gara := "atleti->t_gara4"
            src_punt := "atleti->p_gara4"
         case k == 3
            src_iscr := "atleti->t_iscr3"
            src_gara := "atleti->t_gara3"
            src_punt := "atleti->p_gara3"
         case k == 4
            src_iscr := "atleti->t_iscr1"
            src_gara := "atleti->t_gara1"
            src_punt := "atleti->p_gara1"
         case k == 5
            src_iscr := "atleti->t_iscr5"
            src_gara := "atleti->t_gara5"
            src_punt := "atleti->p_gara5"
         case k == 6
            src_iscr := "atleti->t_iscr2"
            src_gara := "atleti->t_gara2"
            src_punt := "atleti->p_gara2"
      endcase
      if !empty(&src_iscr)
         append blank
         replace tempi->atleta with atleti->codice
         replace tempi->gara with alltrim(str(k, 5))
         replace tempi->t_iscr with &src_iscr
         replace tempi->t_gara with &src_gara
         replace tempi->punti  with &src_punt
      endif
   next k
   sele atleti
   skip
enddo
close data

function scan_480
return nil
