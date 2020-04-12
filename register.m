formatstruct = struct('ext','irm','isa',@isaIRM,'info',@imIRMinfo,'read',@readIRM,'write',@writeIRM,'alpha',0,'description','hamada');
registry = imformats('add',formatstruct);