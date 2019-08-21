%Use these commands to see the output when jobs are finished:

% diary(Et1)
% diary(Et2)
% diary(Et3)
% diary(Et4)

% Use these commands to plot the profiles

addpath '../profiles'

plot_m_Profile('MTprofiles', 'MTprofileEt1_8_39hr25_May_2013', 'profile_CMA_L', 101);
plot_m_Profile('MTprofiles', 'MTprofileEt2_8_39hr25_May_2013', 'profile_CMA_L', 102);
plot_m_Profile('MTprofiles', 'MTprofileEt3_8_39hr25_May_2013', 'profile_CMA_L', 103);
plot_m_Profile('MTprofiles', 'MTprofileEt4_8_39hr25_May_2013', 'profile_CMA_L', 104);
