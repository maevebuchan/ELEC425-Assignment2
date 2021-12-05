function [membership, centres] = k_medoids(X, n_cluster)
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

% Randomly initialize the starting cluster centres.
rng('shuffle');
up_bound = max(X);
lw_bound = min(X);

medoids = datasample(X, n_cluster);

disp('Start K-medoids clustering ... ');
old_membership = ones(n_sample, 1);
show(X, old_membership, n_cluster, medoids, 'Cluster medoids initialized!')

while true

    distance = pdist2(X, medoids,"cityblock"); 
    
    [~, membership] = min(distance, [], 2);
    
    %Show the result of the E step.
    show(X, membership, n_cluster, medoids, 'E step finished: Datapoints re-assigned!')

    disp(medoids)
    
    for j = 1:n_cluster
        
        data = X(membership == j, :)  % Gather all of the data in X which belongs to the current cluseter being analyzed
        distance_recalculated = pdist2(data, data, 'cityblock'); %Calculate the distances between all points in the cluster using manhattan distance.
        distances2 = sum(distance_recalculated);  % Sum the distances for each point to all other points. We will want the point with the minimal distance.
        temp = find(distances2 == min(distances2(:)),1); % find the index of the point with the smallest sum of distances and store in temporary variable
        medoids(j,:) = data(temp,:); % Use that point saved as the new medoid
        
    end
    
    %Show the result of the M step.
    show(X, membership, n_cluster, medoids, 'M step finished: Cluster centers updated!')
    
    % Stop if no more updates.
    if sum(membership ~= old_membership)==0
        show(X, membership, n_cluster, medoids, 'Done! ');
        break;
    end
    
    old_membership = membership;
end
end

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
    
    pause(2);
end
