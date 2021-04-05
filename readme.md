# TOTEM - Topology Optimization Tool for Electric Mobility

![TOTEM Logo](TOTEM logo.png)

TOTEM is a tool that allows for a topological optimization of electric powertrains for passenger vehicles. 
The tool has been developed at the Institute for Automotive Technology (FTM) at Technical University of Munich. (www.ftm.mw.tum.de) 

## Running the Code
The Folder 
```1. Implementation```
contains the tool itself. Apart from that there is a second folder 
```2. Results```
that contains results produced by TOTEM. 

TOTEM has two operation modes: 

* **manual simulation** 
* **optimization**



### Manual Simulation with the GUI
The manual Simulation can be startet by running the ```manual_simulation_GUI.m``` Skript. Initially you can choose between existing and new configurations. In case you go for a new configuration you can decide to save the configuration for later use. Then you can define the powertrain configuration you want to simulate. In the final step you have the choice  various test maneuvers to be simulated. After the simulation of the WLTP-Cycle, the result show up automatically. The results of other maneuvers can be analyzed using the Skripts 
```ANALYSE_plot_simulation.m ```
and 
```ANALYSE_plot_tire_forces.m```.

### Optimization
The Optimization optimizes each topological configuration in a separated process. A topological configuration in that context is the choice of axle configurations for both axles. For each axle there can be chosen between:

1. no propulsion
2. wheel individual propulsion
3. centered propulsion with open differential
4. centered propulsion with torque-vectoring differential

To start an optimization for rear-wheel drives with a standard centerd propulsion with open differential run:

```
Start_Optimization(0,1,3)
```

The first value (0 or 1) is a switch to enable or disable E-Mail-Notifications in case of an error or when finished. 
The second value describes the front axle configuration. 
The third value describes the rear axle configuration. 

Before starting an Optimization the options script should be checked to adjust all options for the optimization:

```
Optimierung_Optionen.m
```

The script allows for an adjustment of the following properties:

* environment / calculation method (local, cluster, parallelized, ...): By default it is set local and non-parallelized
* population and maximum number of generations: By default a population of 4 individual is optimized over 3 generations as an example. To gather real optimization results a population of 64 was optimized over 100 Generations. To achiev results in a suitable time this was done parallel computation. Be aware that this takes 14,5 hours on a 32-core cluster. 
* considered design-variables and their upper and lower boundaries: By default all design-variables are active and bounded within their validated range. Widening their range might be possible but can cause invalid results. 
* objectives: By default costs and consumption are chosen as objectives. Both do not use Simulink-Models but only code-based calculations and models. Thus this choice is suitable for a quick example. 
* boundary conditions: By default there is one boundary condition ensuring that the configuration can follow the velocity-trajectory of the WLTP-Drive-Cycle used for consumption-simulation. 
* objective function: The objective function is called Objective_Function.m

possible designvariables are:

* Motor-type (front and rear)
* nominal Motor-torque (front and rear)
* maximum Motor-speed (front and rear)
* Number of gears (front and rear)
* 1st gear ratio (front and rear)
* ratio between 1st and 2nd gear (dt. Spreizung) (front and rear) 

possible objectives are:

* vehicle dynamics (Fahrdynamik): a weighted sum of all handling, acceleration and traction test maneuvers 
* consumption (Verbrauch): the energy consumption in kWh / 100 km
* costs (Kosten): the production costs of the whole powertrain including the battery in €
* steady state lateral dynamics (stationäre Querdynamik)
* transient lateral dynamics (instationäre Querdynamik)
* combined lateral and longitudinal dynamics (kombinierte Längs- und Querdynamik)
* handling on slippery surface (Verhalten auf Niedrigreibwert)
* top speed (Höchstgeschwindigkeit)

##### Analyzing optimization results 
The script
```result_analysis.m```
includes all functions for analyzing and evaluating the optimization results:

* parsing the output result-file
* identifying pareto-optimal solutions
* plotting pareto-frontiers in 2D and in 3D
* creating a video showing the convergency in the 3D-pareto-frontier
* creating self-organizing maps 
* histograms showing the distribution of design-variables and objectives



## Deployment
  
The tool is developed for [Matlab](https://de.mathworks.com/products/matlab.html) R2018b

The optimization process is computationally expensive. Therefore this process is parallelized to reduce the optimization time using the [Matlab Parallel Computing Toolbox](https://de.mathworks.com/products/parallel-computing.html).

Furthermore 32 Intel Xeon cores of a HPC cluster have been used for optimization.

  

## Contributing and Support
We are strongly encouraged to improve quality, functionality and validity of TOTEM. If you have any Feedback don't hesitate to contact the group leader of the [vehicle concept research group](https://www.ftm.mw.tum.de/en/main-research/vehicle-concepts/) at FTM.



## Versioning

V1.0 Initial public version of TOTEM

## Authors 
TOTEM is part of the dissertation project by Christian Angerer who initiated the project and led the development. 
It includes the contribution of third party code (NSGA2-Implementation by Song Lin,  Copyright (c) 2011) as well as the work of various theses and dissertations by other students and colleagues. 
The exact contribution of the code lines cannot be reproduced. Nevertheless the following list mentions the main persons, that kindly contributed to the overall tool: 

Arend, Julio; Bertele, Josef; Bügel, Joshua; Buß, Alexander; Chang, Fengqi; di Caro, Lorenzo; Eroglu, Isaak; Felgenhauer, Matthias; Gabriele, Stefano; Hillebrand, Simon; Holjevac, Nikola; Holtz, Andreas; Huber, Alexander; Klass, Vladislav; Lestoille, Guillaume; Lübbers, Tim; Lüst, Moritz; Mantovani, Luca; Mildner, Alexander; Mößner, Benedikt; Schultze, Andreas; Tripps, Alexander; Tschochner, Maximilian; Valiyev, Mahammad; Zähringer, Maximlian; Zuchtriegel, Tobias; Wassiliadis, Nikolaos


## Validation
The tool is validated componentwise against real components and holistically against real drive tests with a Tesla Model S. Nevertheless parameterdata are slightly modified in this public Version for reasons of confidentiality. 

## Language
The top-level-language of the tool is in english, nevertheless the lower levels partially are in german. The authors want to excuse for this mixture, which results from a lack of resources for translation. The authors want to strongly encourage the community to support continuous translation to enhance accessibility. 

## License
This project is licensed. See the LICENSE.md file for details.

## Sources and Documentation
The overall method behind the tool is documented in:

* Angerer, Christian: "Antriebskonzept-Optimierung für batterielektrische Allradfahrzeuge", Dissertation, Institute for Automotive Technology, Technical University of Munich, 2019.

Further details can be found in:

* C. Angerer, S. Krapf, A. Buß, and M. Lienkamp, “Holistic Modeling and Optimization of Electric Vehicle Powertrains Considering Longitudinal Performance, Vehicle Dynamics, Costs and Energy Consumption,” in International Design Engineering Technical Conferences & Computers and Information in Engineering Conference (IDETC), Quebec, 2018.
* C. Angerer, M. Felgenhauer, I. Eroglu, M. Zähringer, S. Kalt, and M. Lienkamp, “Scalable Dimension-, Weight- and Cost-Modeling for Components of Electric Vehicle Powertrains,” in International Conference on Electrical Machines and Systems, Seoul, Korea, 2018.
* C. Angerer, B. Mößner, M. Lüst, A. Holtz, F. Sträußl, and M. Lienkamp, “Parameter-Adaption for a Vehicle Dynamics Model for the Evaluation of Powertrain Concept Designs,” in International Conference on New Energy Vehicle and Vehicle Engineering (NEVVE), Seoul, Korea, 2018.

The [Implementation of the NSGA II optimization algorithm](https://de.mathworks.com/matlabcentral/fileexchange/31166-ngpm-a-nsga-ii-program-in-matlab-v1-4) is written by Song Lin and can be downloaded from MathWorks-FileExchange.
The [Identification of pareto-optimal solutions within the results](https://github.com/Sable/mcbench-benchmarks/blob/master/15181-pareto-set/paretoset.m) is written by Yi Cao, Cranfield University and is available on Github. 

Design values and parameters for the design calculation, initialization, simulation  and further parts come from various sources, that are directly mentioned in the code. 