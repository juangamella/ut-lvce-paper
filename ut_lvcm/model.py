# Copyright 2020 Juan Luis Gamella Martin

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:

# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.

# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
"""

import numpy as np
import ut_lvcm.utils as utils

# --------------------------------------------------------------------
# Model class which represents the model, its parameters and additional variables


class Model():
    # TODO: check that psis, omegas are non-megative
    def __init__(self, A, B, gamma, omegas, psis):
        """Create a new instance of a model.

        Parameters
        ----------
        A : numpy.ndarray
            The `p x p` adjacency matrix of the given DAG, where A0[i,j] != 0 implies i -> j.
        B : numpy.ndarray
            The `p x p` connectivity (weight) matrix.
        gamma : numpy.ndarray
            The `l x p` matrix of latent effects, i.e. connectivity
            matrix from latent to observed variables, where
            `gamma[i,j] != 0` implies `i -> j`.
        omegas : numpy.ndarray
            A `e x p` float array containing the estimated noise term
            variances.
        psis : numpy.ndarray
            A `e x l` array containing with the variances of the
            latent variables for each environment.

        Returns
        -------
        NoneType

        Raises
        ------
        ValueError :
            If A is not a DAG adjacency or if B does not respect the
            sparsity pattern in A; if the dimensions of the different
            parameters are not compatible.

        Examples
        --------

        Creating an instance of a model with 3 observed variables, 2 latents and 5 environments.

        >>> rng = np.random.default_rng(42)
        >>> A = np.array([[0,0,1], [0,0,1], [0,0,0]])
        >>> B = np.array([[0,0,0.5], [0,0,3], [0,0,0]])
        >>> gamma = rng.uniform(size=(2,3))
        >>> omegas = rng.uniform(size=(5,3))
        >>> psis = rng.uniform(size=(5,2))
        >>> model = Model(A, B, gamma, omegas, psis)

        >>> model.A
        array([[0, 0, 1],
               [0, 0, 1],
               [0, 0, 0]])


        >>> model.B
        array([[0. , 0. , 0.5],
               [0. , 0. , 3. ],
               [0. , 0. , 0. ]])

        >>> model.gamma
        array([[0.77395605, 0.43887844, 0.85859792],
               [0.69736803, 0.09417735, 0.97562235]])

        >>> model.omegas
        array([[0.7611397 , 0.78606431, 0.12811363],
               [0.45038594, 0.37079802, 0.92676499],
               [0.64386512, 0.82276161, 0.4434142 ],
               [0.22723872, 0.55458479, 0.06381726],
               [0.82763117, 0.6316644 , 0.75808774]])

        >>> model.psis
        array([[0.35452597, 0.97069802],
               [0.89312112, 0.7783835 ],
               [0.19463871, 0.466721  ],
               [0.04380377, 0.15428949],
               [0.68304895, 0.74476216]])

        >>> model.p
        3

        >>> model.e
        5

        >>> model.num_latent
        2

        >>> model.I_B
        array([[ 1. ,  0. ,  0. ],
               [ 0. ,  1. ,  0. ],
               [-0.5, -3. ,  1. ]])

        When A is not a DAG:
        >>> bad_A = np.array([[0,0,1], [0,0,1], [1,0,0]])
        >>> Model(bad_A, B, gamma, omegas, psis)
        Traceback (most recent call last):
        ...
        ValueError: A does not correspond to a DAG.

        When B does not match the sparsity pattern:
        >>> Model(A, B.T, gamma, omegas, psis)
        Traceback (most recent call last):
        ...
        ValueError: B does not respect sparsity pattern in A.

        When the dimensions of the parameters are incompatible:

        >>> bad_B = np.array([[0,0.5], [0,3]])
        >>> Model(A, bad_B, gamma, omegas, psis)
        Traceback (most recent call last):
        ...
        ValueError: A and B have different dimensions.

        >>> bad_gamma = rng.uniform(size=(2,4))
        >>> Model(A, B, bad_gamma, omegas, psis)
        Traceback (most recent call last):
        ...
        ValueError: The sizes of A and gamma are not compatible.

        >>> bad_omegas = rng.uniform(size=(5,2))
        >>> Model(A, B, gamma, bad_omegas, psis)
        Traceback (most recent call last):
        ...
        ValueError: The sizes of A and omegas are not compatible.

        >>> bad_psis = rng.uniform(size=(4,2))
        >>> Model(A, B, gamma, omegas, bad_psis)
        Traceback (most recent call last):
        ...
        ValueError: The sizes of omegas and psis are not compatible.

        >>> bad_psis = rng.uniform(size=(5,3))
        >>> Model(A, B, gamma, omegas, bad_psis)
        Traceback (most recent call last):
        ...
        ValueError: The sizes of gamma and psis are not compatible.

        """
        # Check inputs: A and B
        if A.shape != B.shape:
            raise ValueError("A and B have different dimensions.")
        if not utils.is_dag(A):
            raise ValueError("A does not correspond to a DAG.")
        mask = np.logical_not(A)
        if (B[mask] != 0).any():
            raise ValueError("B does not respect sparsity pattern in A.")

        # Check dimensions (number of variables, latents, environments)
        if gamma.ndim != 2:
            raise ValueError("gamma must be a 2-dimensional array")
        if omegas.ndim != 2:
            raise ValueError("omegas must be a 2-dimensional array")
        if psis.ndim != 2:
            raise ValueError("psis must be a 2-dimensional array")

        #   Number of variables (p)
        if gamma.shape[1] != len(A):
            raise ValueError("The sizes of A and gamma are not compatible.")
        if omegas.shape[1] != len(A):
            raise ValueError("The sizes of A and omegas are not compatible.")

        #   Number of environments
        if omegas.shape[0] != psis.shape[0]:
            raise ValueError(
                "The sizes of omegas and psis are not compatible.")

        #   Number of latent variables
        if gamma.shape[0] != psis.shape[1]:
            raise ValueError("The sizes of gamma and psis are not compatible.")

        # Store model parameters
        self.A = A.copy()
        self.B = B.copy()
        self.gamma = gamma.copy()
        self.omegas = omegas.copy()
        self.psis = psis.copy()

        # Store dimensions and other support variables
        self.num_latent = len(gamma)  # number of latent variables
        self.p = len(B)  # number of observed variables
        self.e = len(omegas)  # number of environments
        self.I_B = (np.eye(self.p) - B.T)

    def copy(self):
        """Returns a copy of the current model.

        Returns
        -------
        copy : Model()
            A copy of this object. All contained arrays are copied
            using ndarray.copy().

        Example
        -------
        >>> _ = model.copy()


        """
        copy = Model(self.A.copy(),
                     self.B.copy(),
                     self.gamma.copy(),
                     self.omegas.copy(),
                     self.psis.copy())
        return copy

    def score(self, sample_covariances, n_obs):
        """Compute the score of the model for the given sample_covariances
        and number of observations from each environment.

        Parameters
        ----------
        sample_covariances : numpy.ndarray
            A 3-dimensional array containing the estimated sample
            covariances of the observed variables for each
            environment.
        n_obs : list of ints
            The number of observations available from each environment
            (i.e. the sample size).

        Returns
        -------
        score : float
            The computed score.

        Examples
        --------
        >>> _ = model.score(sample_covariances, n_obs)

        """
        score = 0
        Ms = self.inv_noise_term_covariances()
        for i, sigma in enumerate(sample_covariances):
            N = self.I_B @ sigma @ self.I_B.T
            score += n_obs[i] * \
                (-np.log(np.linalg.det(Ms[i])) + np.trace(Ms[i] @ N))
            score /= sum(n_obs)
        return score

    def noise_term_covariances(self):
        """Compute the noise-term covariance matrix for each environment.

        Returns
        -------
        noise_term_covariances : numpy.ndarray
            A `e x p x p` array containing the inverse noise-term
            covariance matrices, one per environment.

        Example
        -------
        >>> _ = model.noise_term_covariances()

        """
        Ms = [self.gamma.T @ np.diag(psis_e) @ self.gamma + np.diag(omegas_e)
              for (psis_e, omegas_e) in zip(self.psis, self.omegas)]
        return np.array(Ms)

    def inv_noise_term_covariances(self):
        """Compute the inverse noise term covariance matrix, noted as M, for
        each environment.

        Returns
        -------
        Ms : numpy.ndarray
            A `e x p x p` array containing the inverse noise-term
            covariance matrices, one per environment.

        Example
        -------
        >>> _ = model.inv_noise_term_covariances()

        """
        inv_Ms = []
        for M in self.noise_term_covariances():
            inv_Ms += [np.linalg.inv(M)]
        return np.array(inv_Ms)

    def covariances(self):
        """The covariance matrices of the observed variables, as entailed by
        the model in each environment.

        Returns
        -------
        covariances : numpy.ndarray
            The covariance matrices.

        Example
        -------
        >>> _ = model.covariances()

        """
        covariances = []
        I_B_inv = np.linalg.inv(np.eye(self.p) - self.B.T)
        for noise_term_covariance in self.noise_term_covariances():
            covariance = I_B_inv @ noise_term_covariance @ I_B_inv.T
            covariances.append(covariance)
        return np.array(covariances)

    def sample(self, n_obs, compute_sample_covariances=True, random_state=None):
        """Generate a multi-environment sample from the model.

        Parameters
        ----------
        n_obs : int or list of ints
            The number of observations to generate from each
            environment. If a single number is passed, generate this
            number of observations for all environments.
        sample_covariances : bool, default=True
            If additionally the sample_covariances for the generated
            samples should be computed.

        Returns
        -------
        X : list of numpy.ndarray
            A list containing the sample from each environment.
        sample_covariances : numpy.ndarray
            A 3-dimensional array containing the estimated sample
            covariances of the observed variables for each
            environment. Returned only if
            `compute_sample_covariances=True`.
        n_obs : list of ints
            The number of observations available from each environment
            (i.e. the sample size). Returned only if
            `compute_sample_covariances=True`.

        Raises
        ------
        ValueError :
            If the values passed for n_obs are not positive or the
            length of n_obs does not match the number of environments.
        TypeError :
           If n_obs is not a list of integers.

        Examples
        --------

        >>> _ = model.sample(10)

        >>> _ = model.sample(10, False)

        >>> _ = model.sample([1,2,3,4,5])

        >>> model.sample([1,2])
        Traceback (most recent call last):
        ...
        ValueError: n_obs has the wrong length.

        >>> model.sample([-1,2,3,4,5])
        Traceback (most recent call last):
        ...
        ValueError: n_obs should be a positive integer or list of positive integers.

        >>> model.sample([0,2,3,4,5])
        Traceback (most recent call last):
        ...
        ValueError: n_obs should be a positive integer or list of positive integers.

        >>> model.sample(0)
        Traceback (most recent call last):
        ...
        ValueError: n_obs should be a positive integer or list of positive integers.

        >>> model.sample([1.0,2,3,4,5])
        Traceback (most recent call last):
        ...
        TypeError: n_obs should be a positive integer or list of positive integers.

        >>> model.sample("a")
        Traceback (most recent call last):
        ...
        TypeError: n_obs should be a positive integer or list of positive integers.

        """
        # Check input: n_obs
        msg = 'n_obs should be a positive integer or list of positive integers.'
        #   if single int
        if isinstance(n_obs, int):
            if n_obs > 0:
                n_obs = [n_obs] * self.e
            else:
                raise ValueError(msg)
            #   if list of ints
        elif isinstance(n_obs, list):
            if len(n_obs) != self.e:
                raise ValueError('n_obs has the wrong length.')
            for n in n_obs:
                if not isinstance(n, int):
                    raise TypeError(msg)
                elif n <= 0:
                    raise ValueError(msg)
                #   anything else is a wrong type
        else:
            raise TypeError(msg)

        # Compute population covariances of the observed variables
        covariances = self.covariances()

        # Initialize random generator
        generator = np.random.default_rng(random_state)

        # Sample
        X = []
        for i, covariance in enumerate(covariances):
            # Generate n_obs[i] observations with zero-mean
            sample = generator.multivariate_normal(
                np.zeros(self.p), covariance, n_obs[i])
            X.append(sample)

        # Return appropriately
        if compute_sample_covariances:
            sample_covariances = [np.cov(x, rowvar=False) for x in X]
            return X, np.array(sample_covariances), n_obs
        else:
            return X

    def scaled_latent_incoherence(self):
        """Assumption violation metric 1: Motivated by the incoherence
        (denseness) assumption of the latent effects, the measure
        computes the incoherence of the latent effects estimated by
        the model. See section 3.5 of the paper for more information.

        We output the latent incoherence scaled by the max. degree of
        the moral graph.

        Returns
        -------
        metric : float
            The latent incoherence metric of the model.

        Examples
        --------
        >>> model.scaled_latent_incoherence()
        1.9462534859894438

        """
        # computing reduced SVD of (I-B)^T\Omega_e^{-1}\Gamma with
        # partial orthogonal matrix U (#columns of U is the number of
        # columns of Gamma), then incoherence(e)^2 = largest diagonal
        # entry of UU^T
        max_degree = utils.degrees(utils.moral_graph(self.A)).max()
        incoherences = []
        for omega in self.omegas:
            omega_inv = np.diag(1 / omega)
            # print(omega, omega_inv)
            matrix = (np.eye(self.p)-self.B.T).T @ omega_inv @ self.gamma.T
            U = np.linalg.svd(matrix, full_matrices=False)[0]
            # print(self.gamma.shape, U.shape)
            incoherences.append(np.diag(U@U.T).max())
        # Compute metric
        return max(incoherences) * max_degree

    def intervention_strength(self):
        """Assumption violation metric 2: We described how approximate
        knowledge of the latent variables is enough for
        identifiability as long as the interventions on the observed
        variables are strong. Thus, as a second indicator, we measure
        the strength of the interventions. See section 3.5 of the
        paper for more information.

        Returns
        -------
        metric : numpy.ndarray
            An array of floats with as many entries as variables (p)
            in the model, indicating the strength of the interventions
            over each observed variable.

        Examples
        --------
        >>> model.intervention_strength()
        array([0.0578593 , 0.03265554, 0.12387794])


        """
        metric = np.var(self.omegas, axis=0) / np.max(self.omegas, axis=0)
        return metric

    def __str__(self):
        string = "-" * 70
        string += "\nModel - p:%d - latents:%d - environments:%d\n\n" % (
            self.p, self.num_latent, self.e)

        string += "A:\n"
        string += str(self.A) + "\n\n"

        string += "B:\n"
        string += str(self.B) + "\n\n"

        string += "gamma:\n"
        string += str(self.gamma) + "\n\n"

        string += "omegas:\n"
        string += str(self.omegas) + "\n\n"

        string += "psis:\n"
        string += str(self.psis) + "\n\n"

        string += "Assumption deviation metrics\n"
        string += "  latent incoherence x max. degree of moral graph: %s\n" % self.scaled_latent_incoherence()
        string += "  strength of interventions: %s\n\n" % self.intervention_strength()

        string += "-" * 70 + "\n"

        return string


# --------------------------------------------------------------------
# Doctests
if __name__ == '__main__':
    import doctest
    rng = np.random.default_rng(42)
    A = np.array([[0, 0, 1], [0, 0, 1], [0, 0, 0]])
    B = np.array([[0, 0, 0.5], [0, 0, 3], [0, 0, 0]])
    gamma = rng.uniform(size=(2, 3))
    omegas = rng.uniform(size=(5, 3))
    psis = rng.uniform(size=(5, 2))
    model = Model(A, B, gamma, omegas, psis)
    X, sample_covariances, n_obs = model.sample(
        [100, 200, 300, 400, 500], random_state=42)
    doctest.testmod(extraglobs={'model': model, 'sample_covariances': sample_covariances,
                                'n_obs': n_obs}, verbose=True, optionflags=doctest.ELLIPSIS)
