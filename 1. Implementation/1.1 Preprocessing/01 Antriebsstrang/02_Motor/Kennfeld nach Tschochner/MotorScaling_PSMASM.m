% Powertrain Concept Tool (PCT)
% Prototype software for research purpose
% Contact: MAXIMILIAN KARL TSCHOCHNER, maximilian.tschochner@tum.de
% When using PCT or parts of it please cite:
%   Tschochner, Maximilian Karl: "Comparative Assessment of Vehicle Powertrain
%   Concepts in the Early Development Phase", Dissertation,
%   Technische Universitaet Muenchen, 2018.
% PCT was developed at TUM CREATE in Singapore and at TUM Institute of
% Automotive Technology in Garching near Munich.
 
classdef MotorScaling_PSMASM < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        EffGrid % Efficiency Grid
        ConGrid % Consumption Grid
        MaxTrqLine
        MinTrqLine
        PeakPower_kW
        PeakPowerCurve_kW
        
    end
    
    methods
        
        function E = MotorScaling_PSMASM(motortyp)
            
            % Load and import normalized (=100kW) electric motor map
%             load('ElectricMotor_Normalized.mat');
%             load('ElectricMotor_Normalized_SpeedAsWellPower.mat');
%             load('ElectricMotor_Normalized_WithEdge.mat'); % There is a problem with this map!!! --> find out what
%             load('Initialisierung/Antriebsstrang/Motor/Kennfeld nach Tschochner/ElectricMotor_Normalized_SpeedAsWellPower_ohne_NANs.mat')
%             load('1.1 Preprocessing/Antriebsstrang/Motor/Kennfeld nach Tschochner/ElectricMotor_Normalized_SpeedAsWellPower_ohne_NANs_PSM_ASM.mat')
            load('1.1 Preprocessing/01 Antriebsstrang/02_Motor/Kennfeld nach Tschochner/ElectricMotor_Normalized_SpeedAsWellPower_ohne_NANs_PSM_ASM.mat')

            E.EffGrid = EffGrid;
            if strcmp(motortyp, 'PSM')==1
                E.MaxTrqLine = MaxTrqLine_PSM;            
                % Max/ min torque lines
                E.MinTrqLine.y_Nm = -MaxTrqLine.y_Nm;
                E.MinTrqLine.x_radps = MaxTrqLine.x_radps;
            elseif strcmp(motortyp, 'ASM')==1
                E.MaxTrqLine = MaxTrqLine_ASM;
                % Max/ min torque lines
                E.MinTrqLine.y_Nm = -MaxTrqLine_ASM.y_Nm;
                E.MinTrqLine.x_radps = MaxTrqLine_ASM.x_radps;
                %Maximalwirkungsgrad anpassen --> siehe Dissertation
                %Angerer S. 21 (Kapitel E-Maschine)
                E.EffGrid.zgs_eff(find(E.EffGrid.ygs_Nm>0))=E.EffGrid.zgs_eff(find(E.EffGrid.ygs_Nm>0))./0.951*0.91;
                E.EffGrid.zgs_eff(find(E.EffGrid.ygs_Nm<0))=E.EffGrid.zgs_eff(find(E.EffGrid.ygs_Nm<0))./1.0515*1.1111;
            end
            

            
            % New (symetric!) interpolation of efficiency grid
            % Determine max and min values for interpolation grid
            % x_min = min(E.EffGrid.xgs_radps(:));
            % x_max = max(E.EffGrid.xgs_radps(:));
            % y_min = -max(E.EffGrid.ygs_Nm(:));
            % y_max = max(E.EffGrid.ygs_Nm(:));
            x_min = min(E.MinTrqLine.x_radps(:));
            x_max = max(E.MinTrqLine.x_radps(:));
            y_min = min(E.MinTrqLine.y_Nm(:));
            y_max = max(E.MaxTrqLine.y_Nm(:));
            % Interpolation grid
            x_vec = linspace(x_min, x_max, 300);
            y_vec = linspace(y_min, y_max, 280);
            [xm, ym] = ndgrid(x_vec, y_vec);
            % New interpolation
            % Only interpolate upper part and mirror lower part
            xm_upper = xm( ym >= 0 );
            ym_upper = ym( ym >= 0 );
            ym_lower = ym( ym < 0 );
            zm_upper = interpn(E.EffGrid.xgs_radps, E.EffGrid.ygs_Nm, E.EffGrid.zgs_eff, xm_upper, ym_upper);
            zm_lower = interpn(E.EffGrid.xgs_radps, -E.EffGrid.ygs_Nm, E.EffGrid.zgs_eff, xm_upper, ym_lower);
            % Put upper and lower part together
            zm = [1./zm_lower; zm_upper];
            zm = reshape(zm, size(xm));
            
            E.EffGrid.xgs_radps = xm;
            E.EffGrid.ygs_Nm = ym;
            E.EffGrid.zgs_eff = zm;
            
            %             E.EffGrid.xgs_radps = [E.EffGrid.xgs_radps, E.EffGrid.xgs_radps(:,2:end)];
            %             E.EffGrid.ygs_Nm = [-fliplr(E.EffGrid.ygs_Nm), E.EffGrid.ygs_Nm(:,2:end)];
%             E.EffGrid.zgs_eff = [1./fliplr(E.EffGrid.zgs_eff), E.EffGrid.zgs_eff(:,2:end)];


            
            E.PeakPowerCurve_kW = (E.MaxTrqLine.x_radps .* E.MaxTrqLine.y_Nm) / 1000;
            E.PeakPower_kW = max(E.MaxTrqLine.x_radps .* E.MaxTrqLine.y_Nm) / 1000;
            
            % Berechnung der Verlustleistungsmap (eingefügt von C.
            % Angerer am 11.9.2018)
            E.EffGrid.P_watt=    E.EffGrid.ygs_Nm.*E.EffGrid.xgs_radps;
            E.EffGrid.rel_loss=ones(size(E.EffGrid.P_watt))-E.EffGrid.zgs_eff;
            E.EffGrid.abs_loss_watt=E.EffGrid.rel_loss.*E.EffGrid.P_watt;

        end
        
        function E = Scale(E, PeakPower_kW, PeakSpeed_radps)
            
            
            SpeedScalingFactor = PeakSpeed_radps / 1000;
            
            % Speed Scaling
            E.EffGrid.xgs_radps = E.EffGrid.xgs_radps .* SpeedScalingFactor;
            E.MaxTrqLine.x_radps = E.MaxTrqLine.x_radps .* SpeedScalingFactor;
            E.MinTrqLine.x_radps = E.MinTrqLine.x_radps .* SpeedScalingFactor;
            
            % Calculate New Peak Power
            E.PeakPowerCurve_kW = (E.MaxTrqLine.x_radps .* E.MaxTrqLine.y_Nm) / 1000;
            E.PeakPower_kW = max(E.PeakPowerCurve_kW(:));
            
            % Torque Scaling
            PowerScalingFactor = PeakPower_kW / E.PeakPower_kW;
            E.PeakPowerCurve_kW = (E.MaxTrqLine.x_radps .* PowerScalingFactor .* E.MaxTrqLine.y_Nm) / 1000;
            E.PeakPower_kW = max(E.PeakPowerCurve_kW(:));
            E.MaxTrqLine.y_Nm = PowerScalingFactor .* E.MaxTrqLine.y_Nm;
            E.EffGrid.ygs_Nm = PowerScalingFactor .* E.EffGrid.ygs_Nm;
            E.MinTrqLine.y_Nm = PowerScalingFactor .* E.MinTrqLine.y_Nm;
            
        end
        
        function plot_Efficiency(E)
            
            %% Plot Engine Efficiency Map
            hold on;
            
            % Plot peak torque curve
            plot(E.MaxTrqLine.x_radps, E.MaxTrqLine.y_Nm, 'r-','LineWidth', 3);
            
            % Plot drag torque line
            plot(E.MinTrqLine.x_radps, E.MinTrqLine.y_Nm, 'r-','LineWidth', 3);
            
            % Plot peak power curve
            plot(E.MaxTrqLine.x_radps, E.PeakPowerCurve_kW, 'g-','LineWidth', 3);
            E.PeakPower_kW;
            
            [temp, h] = contour(E.EffGrid.xgs_radps, E.EffGrid.ygs_Nm, E.EffGrid.zgs_eff, [0.6:0.01:1.5], 'b'); %, [0.41:0.01:1]]
            %             [temp, h] = contour(E.ww, E.TT, ee);
            set(h,'ShowText','on','TextStep',get(h,'LevelStep'));
            % legend('Engine Efficiency', 'T_{max}', 'T_{drag}', 'P_{max}');
            xlabel('Rotation Speed in rad/s');
            ylabel('Torque in Nm/ Power in kW');
            title('Engine Efficiency Map');
            grid on;
            
        end
        
        function calc_Consumption(E)
            
            PP_mech_W = E.EffGrid.xgs_radps .* E.EffGrid.ygs_Nm;
            PP_elec_W = PP_mech_W ./ E.EffGrid.zgs_eff;
            
            % Write consumtion grid
            E.ConGrid.xgs_radps = E.EffGrid.xgs_radps;
            E.ConGrid.ygs_Nm = E.EffGrid.ygs_Nm;
            E.ConGrid.zgs_W = PP_elec_W;
            
        end
        
        function plot_Consumption(E)
            
            calc_Consumption(E);
            
            figure;
            hold on;
            
            % Plot max torque curve
            plot(E.MaxTrqLine.x_radps, E.MaxTrqLine.y_Nm, 'r-','LineWidth', 3);
            
            % Plot min torque line
            plot(E.MinTrqLine.x_radps, E.MinTrqLine.y_Nm, 'r-','LineWidth', 3);
            
            % Plot peak power curve
            plot(E.MaxTrqLine.x_radps, E.PeakPowerCurve_kW, 'g-','LineWidth', 3);
            E.PeakPower_kW
            
            [temp, h] = contour(E.ConGrid.xgs_radps, E.ConGrid.ygs_Nm, E.ConGrid.zgs_W, [-150000:10000:150000], 'b'); %, [0.41:0.01:1]]
            %             [temp, h] = contour(E.ww, E.TT, ee);
            set(h,'ShowText','on','TextStep',get(h,'LevelStep'));
            % legend('Engine Efficiency', 'T_{max}', 'T_{drag}', 'P_{max}');
            xlabel('Rotation Speed in rad/s');
            ylabel('Torque in Nm/ Power in kW');
            title('Electric Motor Efficiency Map');
            grid on;
                        
        end
        
        function [ww, TT, Consumption, w, T_max_curve, T_min_curve] = Export(E)
            
           E.calc_Consumption;
           
           ww = E.ConGrid.xgs_radps;
           TT = E.ConGrid.ygs_Nm;
           Consumption = E.ConGrid.zgs_W;
           w = E.MaxTrqLine.x_radps;
           T_max_curve = E.MaxTrqLine.y_Nm;
           T_min_curve = E.MinTrqLine.y_Nm;
            
        end
        
        
        
    end
    
end

