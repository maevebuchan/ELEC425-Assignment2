function [membership, medoids] = k_medoids(X, n_cluster)
% X: the data matrix, rows are data points and columns are features
% n_cluster: number of cluster

if n_cluster > 4
    disp ('You have set too many clusters.');
    disp ('Set the number of clusters to be 1-4.');
    disp ('The program and visualization allow for up to 4 clusters.');
    return;
end

% Initialize the figure
figure('position', [200, 200, 600, 500]);
    
% Get the number of data points and number of features
[n_sample, n_feat] = size(X); 

% n_sample is the number of data points
% n_feat is the number of features
% n_cluster is the number of clusters

% Randomly initialize the starting cluster centres.
rng('shuffle');

% instead of definining centres through an equation, select a random matrix
% value to be medoid 

% here, select n_cluster # of random medoids
medoids = datasample(X, n_cluster);

disp('Start K-medoids clustering ... ');

% Initialization:
% In the begining, all data points are in cluster 1
% The "old_membership" variable is an n_sample-by-1 matrix.
% It saves the cluster id that each data point belongs to.
% Again, in the begining, all data points are in cluster 1
old_membership = ones(n_sample, 1);

% Display the initial cluster membership for all datapoints
% and the initial cluster centres
show(X, old_membership, n_cluster, medoids, 'Cluster medoids initialized!');

while true
    % calculate the distance between all points and all medoids 
    distance = pdist2(X, medoids, 'cityblock');
    
    % E step: Assign data points to closest medoid to make cluster.
    
    % Save your assignment to the variable "membership", 
    % which is an n_sample-by-1 vector and each row saves 
    % the cluster membership of a datapoint.
    
    [~, membership] = min(distance, [], 2);
    
    %Show the result of the E step.
    show(X, membership, n_cluster, medoids, 'E step finished: Datapoints re-assigned!')
   
    % Now randomly select a non-medoid object and see if this reduces the 
    % sum square error (improves quality of cluster)
    % If it does, assign this as medoid
    
    for i = 1:medoids
    % for each medoid
        for j = 1:sum(membership == i)
        % for the number of points assigned to each medoid cluster i
            for k = 1:length(distance(:, 1))
        
            % randomly select new medoid point within cluster i
            idx = datasample(find(membership==i), 1); % returns index where membership is a point in a cluster of medoid i
            new_medoid(i, :) = X(idx, :);
            
            % swap medoid and random other non-medoid point
            [new_medoid(i, :), medoids(i, :)] = deal(medoids(i, :), new_medoid(i, :));
            
            % calculate new distances to new medoid
            distance_recalculated = pdist2(X, medoids, 'cityblock');
            
            % save new memberships 
            [~, membership_recalculated] = min(distance_recalculated, [], 2);
            
            %show(X, membership_recalculated, n_cluster, medoids, 'Reassignments finished');
            mean_original = mean(distance(:, i));
            mean_new = mean(distance_recalculated(:, i));
            
            
            error_original = (distance(k, i) - mean_original)^2;
            error_new = (distance_recalculated(k, i) - mean_new)^2;
            
            if error_new > error_original
                % swap back 
                [medoids(i, :), new_medoid(i, :)] = deal(new_medoid(i, :), medoids(i, :));
            % else, keep going with new assignment that we made
            end
            
            % LOST HERE!! ^^^^^ above
            % not sure if i am calculating the error right.. also not sure
            % how to add termination condition when best medoids are
            % chosen...? 
            
            end % for k end
        end % for j end
    end % for i end
        
%     for i = 1:n_cluster
%         
%     end
%         
%     j = 1;
%     if j <= n_cluster
%         [~, index] = mink(sum(pdist2(X(membership == j,:), X(membership == j,:),'cityblock')),1);
%         n_medoid(:,:) = findIndex(index, X, n_cluster, j);
%     end
        
    % Show the result of the M step.
    %show(X, membership, n_cluster, medoids, 'M step finished: Cluster centers updated!')
    
    % Stop if no more updates
    %if sum(membership ~= old_membership)==0
        %show(X, membership, n_cluster, medoids, 'Done! ');
        %break;
    %end
end % end while
end % end function k_medoids

function show(X, c_pred, n_cluster, medoids, txt)
    symbol = ['ro'; 'gp'; 'bd'; 'k^'; 'r*'];
    hold off;
        
    for i = 1:n_cluster
        marker = mod(i,5);
        if i > 4            
            disp('Total number of clusters exceeds 4, some symbols in the plot are reused!');
        end
        plot(X(c_pred==i, 1), X(c_pred==i, 2), symbol(marker,:));
        hold on;
        plot(medoids(i, 1), medoids(i, 2), symbol(marker,2), 'MarkerFaceColor',symbol(marker,1));
    end
    text(4.2, 5.4, txt);
    drawnow;
    
    %Pause some time here.
    %Used to show figure with enough time.
    %You can change the pause time.
    pause(0.5);
    
end % end function show
 



