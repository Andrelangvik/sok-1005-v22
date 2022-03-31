{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "85d5b0cf-cd65-44b5-83f2-ad4b380c60aa",
   "metadata": {},
   "outputs": [],
   "source": [
    "import numpy as np\n",
    "\n",
    "def player_strategy(n_battalions,n_fields):\n",
    "    #defining the array:\n",
    "    battalions=np.zeros(n_fields,dtype=int)\n",
    "    \n",
    "    #assigning 25 battalions to the first four battle fields:\n",
    "    battalions[0:1]= 20\n",
    "    battalions[2:3]= 12\n",
    "    battalions[1:2]= 32\n",
    "    battalions[3:]= 12\n",
    "    \n",
    "    \n",
    "    #asserting that all and no more than all battalions are used:\n",
    "    battalions=battalions[np.random.rand(n_fields).argsort()]\n",
    "    assert sum(battalions)==n_battalions\n",
    "    \n",
    "    return battalions"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "c0cf1585-7f2e-4726-930d-515e2479caba",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.9.9"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
