# define grid
# define grid with refined spacing near cathode and other critical regions

line x location=-52.0 spacing=@x_grid@
line x location=0.0 spacing=5.0 tag=top
line x location=@sub_height@ spacing=@x_grid@ tag=bottom

line y location=0.0 spacing=@y_grid@ tag=left
line y location=75.0 spacing=@y_grid@ tag=right

# Remeshing Strategy
grid set.min.normal.size=0.5 set.normal.growth.ratio.2d=2.0

# define substrate structure
region Silicon xlo=top xhi=bottom ylo=left yhi=right
init field=Boron concentration=@sub_dose@ !DelayFullD

# define mask
mask name=jte left=55.0 right=65.0
mask name=n+ left=0.0 right=55.0
mask name=pgain left=0.0 right=55.0
mask name=pstop left=70.0 right=75.0
mask name=oxide left=0.0 right=55.0
mask name=cathode left=65.0 right=75.0
mask name=anode left=0.0 right=75.0
mask name=metal left=55.0 right=70.0  

math coord.ucs

deposit Silicon type=isotropic thickness=50 species=Boron concentration=@epitaxial_dose@

#implant pgain layer
photo mask=pgain thickness=1.0
implant Boron energy=256 dose=@pgain_dose@ tilt=@tilt@
strip resist

# implant n+ layer
photo mask=n+ thickness=1.0
implant Phosphorus energy=100 dose=@n+dose@ tilt=@tilt@
strip resist

# anneal
diffuse temperature=900 time=90<s> 

# implanst pstop
photo mask=pstop thickness=1.0
implant Boron energy=50 dose=@pstop_dose@ tilt=@tilt@
strip resist

# implant jte 
photo mask=jte thickness=1.0
#implant Phosphorus energy=600 dose=@jte_dose@ tilt=@tilt@
implant Phosphorus energy=450 dose=@jte_dose@ tilt=@tilt@
strip resist

diffuse temperature=450 time=10<s>

# SiO2
deposit material=SiO2 type=isotropic thickness=1.0 mask=oxide

# Cathode
deposit Aluminum type=isotropic thickness=1.0 mask=cathode
# etch aluminum anisotropic thickness=1.0 mask=cathode

transform flip

# Anode
deposit Aluminum type=isotropic thickness=1.0
etch aluminum anisotropic thickness=1.0 mask=anode
# contact name=anode box Aluminum

transform flip

transform reflect left

contact name=cathode box Aluminum xlo=-50.0 xhi=-51.0 ylo=-55.0 yhi=55.0
contact name=anode box Aluminum xlo=@sub_height@ xhi=@sub_height@+1.0 ylo=-75.0 yhi=75.0


struct tdr=n@node@_fps
