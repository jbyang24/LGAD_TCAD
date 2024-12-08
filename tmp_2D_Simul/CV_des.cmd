Device "LGAD" {
	File {
		Grid="n@node|-2@_fps.tdr"
		Plot="@tdrdat@"
		Parameter="@parameter@"
		Current="@plot@"
	}
	Electrode {
		{ Name="anode" Voltage=0.0 }
		{ Name="cathode" Voltage=0.0 }
	}
  Thermode {
    { Name="anode" Temperature=240 }
    { Name="cathode" Temperature=240 }
  }
	Physics {
		Fermi
		EffectiveIntrinsicDensity( OldSlotboom )
		Mobility(
			DopingDependence
			eHighFieldsaturation( GradQuasiFermi )
			hHighFieldsaturation( GradQuasiFermi )
			Enormal
		)
		Recombination(
			SRH( DopingDependence TempDependence )
		)
	}
}

Plot {
  *--Density and Currents, etc
  eDensity hDensity
  TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
  eMobility hMobility
  eVelocity hVelocity
  eQuasiFermi hQuasiFermi
  
  *--Temperature 
  eTemperature Temperature * hTemperature
  
  *--Fields and charges
  ElectricField/Vector Potential SpaceCharge
  
  *--Doping Profiles
  Doping DonorConcentration AcceptorConcentration
  
  *--Generation/Recombination
  SRH Band2BandGeneration * Auger
  ImpactIonization eImpactIonization hImpactIonization
  
  *--Driving forces
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  eEparallel hEparallel eENormal hENormal
  
  *--Band structure/Composition
  BandGap 
  BandGapNarrowing
  Affinity
  ConductionBand ValenceBand
  eQuantumPotential
}

Math {
  RelErrControl
  Digits=5                  * (default)
  ErrRef(electron)=1.e10    * (default)
  ErrRef(hole)=1.e10        * (default)
  Iterations=20
  Notdamped=100
  Method=Blocked
  SubMethod=Super
  ACMethod=Blocked 
  ACSubMethod=Super
}

File {
  Output    = "@log@"
  ACExtract = "@acplot@"
}


System {
	LGAD lgad ( anode=a cathode=c )
	Vsource_pset va (a 0) { dc=0.0 }
	Vsource_pset vc (c 0) { dc=0.0 }
}

Solve {
  
  NewCurrentPrefix="init_"
  Coupled(Iterations=100){ Poisson }
  Coupled{ Poisson Electron Hole  }
  
  Quasistationary ( 
    InitialStep=1.0e-7 Increment=1.41
    MaxStep=0.01 Minstep=1.0e-10 
    Goal { Parameter=vc.dc Voltage=0.0 }
  ){ Coupled { Poisson Electron Hole } }
  
  NewCurrentPrefix=""
  Quasistationary (
    InitialStep=1.0e-7 Increment=1.41
    MaxStep=0.01 Minstep=1.0e-10
    Goal { Parameter=va.dc Voltage=-100.0 }
  ){ ACCoupled (
      StartFrequency=@frequency@ EndFrequency=@frequency@ NumberOfPoints=1 Decade
      Node(a c) Exclude(va vc) 
      ACCompute (Time = (Range = (0 1)  Intervals = 100))
  ){ Poisson Electron Hole }
  }
  Quasistationary (
    InitialStep=1.0e-7 Increment=1.41
    MaxStep=0.01 Minstep=1.0e-10
    Goal { Parameter=va.dc Voltage=-200.0 }
  ){ ACCoupled (
      StartFrequency=@frequency@ EndFrequency=@frequency@ NumberOfPoints=1 Decade
      Node(a c) Exclude(va vc) 
      ACCompute (Time = (Range = (0 1)  Intervals = 100))
  ){ Poisson Electron Hole }
  }
  Quasistationary (
    InitialStep=1.0e-7 Increment=1.41
    MaxStep=0.01 Minstep=1.0e-10
    Goal { Parameter=va.dc Voltage=-300.0 }
  ){ ACCoupled (
      StartFrequency=@frequency@ EndFrequency=@frequency@ NumberOfPoints=1 Decade
      Node(a c) Exclude(va vc) 
      ACCompute (Time = (Range = (0 1)  Intervals = 100))
  ){ Poisson Electron Hole }
  }
  Quasistationary (
    InitialStep=1.0e-7 Increment=1.41
    MaxStep=0.01 Minstep=1.0e-10
    Goal { Parameter=va.dc Voltage=-400.0 }
  ){ ACCoupled (
      StartFrequency=@frequency@ EndFrequency=@frequency@ NumberOfPoints=1 Decade
      Node(a c) Exclude(va vc) 
      ACCompute (Time = (Range = (0 1)  Intervals = 100))
  ){ Poisson Electron Hole }
  }
}