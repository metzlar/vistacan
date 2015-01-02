VCAN    ; VistACan mumps routines 
        ; author: Ivan Metzlar <metzlar@gmail.com>
        ;
CREATEVISITWNOTE(PRV,DFN,DIA,CONTENT) ;
        D DT^DICRW
        S DUZ=PRV
        ; get the visit timestamp
        S VDT=""
        D DT^ORWU(.VDT,"NOW")
        ; create a general visit (1467) note for patient w/DFN 
        ; at location 11 (DR OFFICE)
        S NIEN=""
        S TITLE="1467",VLOC="11",VSIT="",TIUX="",VSTR="11;"_VDT_";I",SUPPRESS="",NOASF="1"
        D MAKE^TIUSRVP(.NIEN,DFN,TITLE,VDT,VLOC,VSIT,.TIUX,VSTR,SUPPRESS,NOASF)
        ; create a visit with diagnose DIA 
        S OK=""
        S PCELIST(1)="HDR"_U_"1"_U_U_VSTR
        S PCELIST(2)="VST"_U_"DT"_U_VDT
        S PCELIST(3)="VST"_U_"PT"_U_DFN
        S PCELIST(4)="VST"_U_"HL"_U_VLOC
        S PCELIST(5)="VST"_U_"VC"_U_"I"
        S PCELIST(6)="PRV"_U_PRV_U_U_U_U_"1"
        S PCELIST(7)="POV+"_U_DIA_U_U_U_"1"_U_PRV_U_"1"_U_U_U
        D SAVE^ORWPCE(.OK,.PCELIST,NIEN,VLOC)
        S TIUY=""
        S TIUDA=NIEN
        S TIUX("TEXT",1,0)=CONTENT
        S TIUX("HDR")="1"_U_"1"
        S SUPPRESS="0"
        D SETTEXT^TIUSRVPT(.TIUY,TIUDA,.TIUX,SUPPRESS)
        Q
