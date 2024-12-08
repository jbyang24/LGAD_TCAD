File{
   Grid      = "n@node|-1@_fps.tdr"
   Plot      = "n@node@.plt"
   Current   = "Electical_n@node@"
   Output    = "Electical_n@node@"
}

Electrode{
   { Name="anode" Voltage=0.0 }
   { Name="cathode" Voltage=0.0 }
}
Physics{
   Temperature=300
   Fermi
   EffectiveIntrinsicDensity( OldSlotboom )     
   Mobility(
      DopingDep
      eHighFieldsaturation( GradQuasiFermi )
      hHighFieldsaturation( GradQuasiFermi )
      Enormal
   )
   Recombination(
      SRH( DopingDep TempDependence )
      Auger
      Band2Band
      Avalanche
      AvalancheGeneration
   )          
}

Plot{
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   eMobility hMobility
   eVelocity hVelocity
   eQuasiFermi hQuasiFermi

*--Temperature 
   eTemperature Temperature * hTemperature

*--Fields and charges
   * ElectricField/Vector Potential SpaceCharge
   ElectricField

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH * Band2Band
   Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap 
   BandGapNarrowing
   Affinity
   ConductionBand ValenceBand
   
}

Math {
   Number_Of_Threads=8
   Extrapolate
   Derivatives
   * Iterations= 200
   * Iterations= 100
   Iterations= 50
   Notdamped= 100
   * Method= Blocked
   Method=PARDISO
   SubMethod= ILS
   * BreakCriteria{Current(Contact= "anode" AbsVal= 1e-3)}
}

Solve {
   *- Build-up of initial solution:
*-   NewCurrentPrefix="init_"
   * Coupled(Iterations=100){ Poisson  }
   Coupled(Iterations=100){ Poisson Electron Hole  }
   
   Quasistationary(
      InitialStep=1e-4 MinStep=1e-10 MaxStep=0.01
       Increment=1.3 Decrement=1.5
      Goal{ Name="anode" Voltage=-100.0 }
   ) { Coupled { Poisson Electron Hole  }
       CurrentPlot(Time=(Range=(0 1) Intervals=100))
     }
   Quasistationary(
      InitialStep=1e-4 MinStep=1e-10 MaxStep=0.01
       Increment=1.3 Decrement=1.5
      Goal{ Name="anode" Voltage=-200.0 }
   ) { Coupled { Poisson Electron Hole  }
       CurrentPlot(Time=(Range=(0 1) Intervals=100))
     }
        Quasistationary(
      InitialStep=1e-4 MinStep=1e-10 MaxStep=0.01
       Increment=1.3 Decrement=1.5
      Goal{ Name="anode" Voltage=-300.0 }
   ) { Coupled { Poisson Electron Hole  }
       CurrentPlot(Time=(Range=(0 1) Intervals=100))
     }
             Quasistationary(
      InitialStep=1e-4 MinStep=1e-10 MaxStep=0.01
       Increment=1.3 Decrement=1.5
      Goal{ Name="anode" Voltage=-400.0 }
   ) { Coupled { Poisson Electron Hole  }
       CurrentPlot(Time=(Range=(0 1) Intervals=100))
     }
}
