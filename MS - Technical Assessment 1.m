customer = [1:10];
labels = {'Customer', 'IAT', 'Arrival Time', 'Service Time', ...
          'Time Service Begins', 'Time Service Ends', ...
          'Time Customer waits in Queue', 'Time Customer Spends in System', ...
          'Time the System is IDLE'};
IAT = [0 8  6  1  8  3  8  7  2  3];
arrival_time = [0 8 14 15 23 26 34 41 43 46];
service_time = [4 1  4  3  2  4  5  4  5  3];
time_service_begins  = [];
time_service_ends    = [];
time_customer_waits  = [];
time_customer_system = [];
time_system_idle     = [];
cust_queue           = [];
current_serving      = [];
time = -1;
time_idle = -1;

% saves all the data before iterating
data = [customer' IAT' arrival_time' service_time']; 
total = {'T'};
while true
    % Check and add customers to the qeueu if arrival_time is empty and 
    % if the current time is equal to the earliest time in arrival_time
    if ~isempty(arrival_time)
        if time == arrival_time(1) % checks the earliest time in arrival_time
            cust_queue = [cust_queue; [customer(1), service_time(1), 0]]; % adds customer to the queue
            customer(1) = [];      %
            service_time(1) = [];  % Removes the customer details in all the array
            arrival_time(1) = [];  %
        end
    end
    
    
    if isempty(current_serving) && ~isempty(cust_queue)   % checks if there is an active customer 
        time_system_idle = [time_system_idle time_idle];  % adds the idle time in the array
        time_idle = 0;                                    % then resets it
        
        time_service_begins = [time_service_begins time]; % adds the current time in the array to save the time the service begins to the current customer
        current_serving = [current_serving cust_queue(1, :)]; % gets the first customer inside the queue
        
        
        time_customer_waits = [time_customer_waits cust_queue(1, 3)];  % gets the total queue wait time of the current customer
        cust_queue(1, :) = [];                                         % then removes it
        
        time_customer_system = [time_customer_system ...      % gets the queue time and the service time
            current_serving(1, 2) + current_serving(1, 3)];   % to get the total time the customer is in the system
        
        current_serving(2) = current_serving(2) - 1; % decrements the service time of the current customer
        
    elseif ~isempty(current_serving) % checks if there is an active customer
        
        % checks if the service time of active customer is 0 if zero,
        % removes the customer then saves the time. If not 0, then 
        % subtract 1 to the service time
        if current_serving(2) == 0     
            current_serving = [];
            time_service_ends = [time_service_ends time];
            
            % checks the queue if not empty to prevent pre-mature end
            % of the program
            if ~isempty(cust_queue)
                continue;
            end
        else
            current_serving(2) = current_serving(2) - 1;
        end
    end
    
    % loop will end if there is no active customer and if queue and
    % customer list is empty
    if isempty(current_serving) && isempty(customer) && isempty(cust_queue)
        break
    elseif isempty(current_serving) && isempty(cust_queue)
        time_idle = time_idle + 1;
    end
    
    time = time + 1;
    service_time = [4 1  4  3  2  4  5  4  5  3];
    % adds 1 to the queue time of all customer in the queue
    if ~isempty(cust_queue)
        for i = 1:size(cust_queue, 1)
            cust_queue(i, 3) = cust_queue(i, 3) + 1;
        end
    end
end


% Andito lahat ng data
data = [data time_service_begins' time_service_ends' time_customer_waits' ...
    time_customer_system' time_system_idle'];

 total = [total,sum(IAT),0,sum(service_time),0, sum(time_customer_waits),0, sum(time_customer_system), sum(time_system_idle)];
labels = {'Customer', 'IAT', 'Arrival Time', ...
           'Service Time', 'Time Service Begins', 'Time Service Ends', ... 
           'Time Customer waits in Queue', 'Time Customer Spends in System', ...
           'Time the System is IDLE'};
 
 % outputs the program as a table figure.
 D = num2cell(data);
 data = [D;total];
 F = figure;
 
 T = uitable(F, 'data', data, 'columnname', labels);

